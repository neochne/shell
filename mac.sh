# network variables
NETWORK_SERVICE="USB 10/100 LAN"
#NETWORK_SERVICE="USB 10/100/1000 LAN"
#NETWORK_SERVICE="Wi-Fi"
#NETWORK_SERVICE="MT65xx Preloader"
PROXY_HOST=127.0.0.1
PROXY_PORT=1086

# ss rust variables
SS_CFG_JSON_FILE=/Users/sharp/sdk/ss/ss_rust/cfg.json
SS_PID_FILE=/Users/sharp/sdk/ss/ss_rust/ss_rust_client.pid

# ################################## Mac #####################################

mac_battery() {
    ioreg -rn AppleSmartBattery | grep -i "MaxCapacity\|Designcapacity"
}

# ################################## Rust ss #####################################

is_rust_ss_client_run() {
    if test -f "$SS_PID_FILE"; then
        return 0
    else
        return 1
    fi
}

show_rust_ss_client_status() {
    if is_rust_ss_client_run; then
        pid=`cat $SS_PID_FILE`
        echo "rust ss client is already run on [$pid] ✅ "
    else
        echo "rust ss client is not run ❌ "
    fi
}

start_rust_ss_client() {
    if is_rust_ss_client_run; then
        pid=`cat $SS_PID_FILE`
        echo "rust ss client is already run on [$pid] ✅ "
        return 0
    fi

    /Users/sharp/sdk/ss/ss_rust/sslocal -c $SS_CFG_JSON_FILE --daemonize-pid $SS_PID_FILE

    pid=`cat $SS_PID_FILE`
    echo "start rust ss client on [$pid] success! ✅ "
}

stop_rust_ss_client() {
    if ! is_rust_ss_client_run; then
        echo "rust ss client is not run ❌ "
        return 0
    fi

    cat $SS_PID_FILE | xargs kill -9
    pid=`cat $SS_PID_FILE`
    rm -fr $SS_PID_FILE

    echo "stop rust ss client on [$pid] success! ✅ "
}

# ################################## Network status #####################################

list_all_network() {
    networksetup -listallnetworkservices
}

is_network_socks_proxy_on() {
    local NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"
    socks_state_details=$(networksetup -getsocksfirewallproxy "$NETWORK_SERVICE")
    if echo "$socks_state_details" | grep -q "Enabled: Yes"; then
        return 0
    else
        return 1
    fi
}

show_network_socks_proxy_status() {
    local NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"
    echo "=== network [${NETWORK_SERVICE}] Status: ==="
    networksetup -getsocksfirewallproxy "$NETWORK_SERVICE"
    echo ""
    echo "=== network [${NETWORK_SERVICE}] Bypass: ==="
    networksetup -getproxybypassdomains "$NETWORK_SERVICE"
}

# ################################## GUI socks proxy #####################################

set_gui_network_socks_proxy() {
    NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"
    PROXY_HOST=${2:-$PROXY_HOST}
    PROXY_PORT=${3:-$PROXY_PORT}

    if is_network_socks_proxy_on $NETWORK_SERVICE; then
        echo "network [${NETWORK_SERVICE}] is already set gui socks proxy on [$PROXY_HOST:$PROXY_PORT] ✅ "
        return 0
    fi

    if ! is_rust_ss_client_run; then
        start_rust_ss_client
    fi

    networksetup -setsocksfirewallproxy "$NETWORK_SERVICE" $PROXY_HOST $PROXY_PORT
    
    # Bypass
    networksetup -setproxybypassdomains "$NETWORK_SERVICE" \
        "localhost" "127.0.0.1" "::1" "*.local" "169.254.*" \
        "10.*" "172.16.*" "172.17.*" "172.18.*" "172.19.*" \
        "172.20.*" "172.21.*" "172.22.*" "172.23.*" "172.24.*" \
        "172.25.*" "172.26.*" "172.27.*" "172.28.*" "172.29.*" \
        "172.30.*" "172.31.*" "192.168.*" "fe80::%*"
    
    echo "set network [${NETWORK_SERVICE}] gui socks proxy on [$PROXY_HOST:$PROXY_PORT] success! ✅ "
}

unset_gui_network_socks_proxy() {
    NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"

    if ! is_network_socks_proxy_on $NETWORK_SERVICE; then
        echo "network [$NETWORK_SERVICE] is not set gui socks proxy ❌ "
        return 0
    fi

    networksetup -setsocksfirewallproxystate "$NETWORK_SERVICE" off
    networksetup -setproxybypassdomains "$NETWORK_SERVICE" "Empty"

    echo "stop network [${NETWORK_SERVICE}] gui socks proxy success! ✅ "
}

# ################################## Terminal socks proxy #####################################

is_terminal_network_socks_proxy_on() {
    if [ -n "${ALL_PROXY}" ]; then
        return 0
    else
        return 1
    fi
}

show_terminal_network_socks_proxy_status() {
    if is_terminal_network_socks_proxy_on; then
        echo "terminal network socks proxy is already set on [${PROXY_HOST}:${PROXY_PORT}] ✅ "
    else
        echo "terminal network socks proxy is not set ❌ "
    fi
}

set_terminal_network_socks_proxy() {
    PROXY_HOST=${1:-$PROXY_HOST}
    PROXY_PORT=${2:-$PROXY_PORT}
    
    if is_terminal_network_socks_proxy_on; then
        echo "terminal network socks proxy is already set on [${PROXY_HOST}:${PROXY_PORT}] ✅ "
        return 0
    fi

    if ! is_rust_ss_client_run; then
        start_rust_ss_client
    fi

    export ALL_PROXY=socks5://${PROXY_HOST}:${PROXY_PORT}
    echo "set terminal network socks proxy on [${PROXY_HOST}:${PROXY_PORT}] success! ✅ "
}

unset_terminal_network_socks_proxy() {
    if ! is_terminal_network_socks_proxy_on; then
        echo "terminal network socks proxy is not set ❌ "
        return 0
    fi

    unset ALL_PROXY
    echo "unset terminal network socks proxy success! ✅ "
}

# ################################## Command #####################################

# 1) 直接执行 mac.sh ssproxyterminal {set|unset|status} 会失效，因为方法里涉及到了环境变量，而执行 mac.sh 会开启
#    一个新的子 Shell 进程，对环境变量的操作只会大子 Shell 中生效，不会影响到父 Shell，如果要用 mac.sh 这种方式
#    执行，需要用 source 命令，即：source mac.sh ssproxyterminal {set|unset|status}，但这种方式会使脚本中的所有
#    函数生效，所以还不如直接 source mac.sh 然后在终端中直接调用函数，暂时放弃下面这种方式吧-_-(2025-10-24 20:00:00)

if true; then
return 0
fi
echo "xxxyy"

case "$1" in
    battery)
        mac_battery
        ;;
    network)
        case "$2" in
            all)
                list_all_network
                ;;
            ssproxystatus)
                show_network_socks_proxy_status "$3"
                ;;
            *)
                echo "Usage: $0 $1 {all|ssproxystatus}"
        esac
        ;;
    ssclient)
        case "$2" in
            start)
                start_rust_ss_client
                ;;
            stop)
                stop_rust_ss_client
                ;;
            status)
                show_rust_ss_client_status
                ;;
            *)
                echo "Usage: $0 $1 {start|stop|status}"
        esac
        ;;
    ssproxygui)
        case "$2" in
            set)
                set_gui_network_socks_proxy "$3" "$4" "$5"
                ;;
            unset)
                unset_gui_network_socks_proxy "$3"
                ;;
            *)
                echo "Usage: $0 $1 {set|unset}"
        esac
        ;;
    ssproxyterminal)
        case "$2" in
            set)
                set_terminal_network_socks_proxy "$3" "$4"
                ;;
            unset)
                unset_terminal_network_socks_proxy
                ;;
            status)
                show_terminal_network_socks_proxy_status
                ;;
            *)
                echo "Usage: $0 $1 {set|unset|status}"
        esac
        ;;
    *)
        echo "Usage: $0 {battery|network|ssclient|ssproxygui|ssproxyterminal}"
        exit 1
        ;;
esac
