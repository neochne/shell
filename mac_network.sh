# ################################## Variables #####################################

# interface
# NETWORK_INTERFACE="USB 10/100/1000 LAN"
# NETWORK_INTERFACE="Wi-Fi"
# NETWORK_INTERFACE="MT65xx Preloader"
NETWORK_INTERFACE="USB 10/100 LAN"

# socks proxy
SOCKS_PROXY_HOST=127.0.0.1
SOCKS_PROXY_PORT=1086

# http proxy
HTTP_PROXY_HOST=127.0.0.1
HTTP_PROXY_PORT=1088

# https proxy
HTTPS_PROXY_HOST=127.0.0.1
HTTPS_PROXY_PORT=1088

# ################################## Network interface #####################################

_list_all_network_interfaces() {
    networksetup -listallnetworkservices
}

nwallinterfaces() {
    _list_all_network_interfaces
}

# ################################## GUI proxy #####################################

_is_gui_network_proxy_on() {
    local proxy_details=$(networksetup $1 "$2")
    if echo "$proxy_details" | grep -q "Enabled: Yes"; then
        return 0
    else
        return 1
    fi
}

_show_gui_network_proxy_status() {
    echo "=== [$3] network [$2] proxy Status: ==="
    networksetup $1 "$3"
    echo ""
    echo "=== [$3] network [$2] Bypass: ==="
    networksetup -getproxybypassdomains "$3"
}

_set_gui_network_proxy() {
    NETWORK_INTERFACE="${6:-$NETWORK_INTERFACE}"
    if _is_gui_network_proxy_on $1 $NETWORK_INTERFACE; then
        echo "network [$NETWORK_INTERFACE] is already set gui [$5] proxy on [$3:$4] ✅ "
        return 0
    fi

    if ! _is_rust_ss_client_run; then
        _start_rust_ss_client
    fi

    networksetup $2 "$NETWORK_INTERFACE" $3 $4
    
    # Bypass
    networksetup -setproxybypassdomains "$NETWORK_INTERFACE" \
        "localhost" "127.0.0.1" "::1" "*.local" "169.254.*" \
        "10.*" "172.16.*" "172.17.*" "172.18.*" "172.19.*" \
        "172.20.*" "172.21.*" "172.22.*" "172.23.*" "172.24.*" \
        "172.25.*" "172.26.*" "172.27.*" "172.28.*" "172.29.*" \
        "172.30.*" "172.31.*" "192.168.*" "fe80::%*"
    
    echo "set network [$NETWORK_INTERFACE] gui [$5] proxy on [$3:$4] success! ✅ "
}

_unset_gui_network_proxy() {
    if ! _is_gui_network_proxy_on $1 $NETWORK_INTERFACE; then
        echo "network [$NETWORK_INTERFACE] is not set gui [$4] proxy ❌ "
        return 0
    fi

    networksetup $3 "$NETWORK_INTERFACE" 'Empty' 'Empty'
    networksetup $2 "$NETWORK_INTERFACE" off
    networksetup -setproxybypassdomains "$NETWORK_INTERFACE" 'Empty'

    echo "unset network [$NETWORK_INTERFACE] gui [$4] proxy success! ✅ "
}

nwguisocksproxystatus() {
    _show_gui_network_proxy_status -getsocksfirewallproxy 'socks' "$NETWORK_INTERFACE"
}

nwguisocksproxyon() {
    SOCKS_PROXY_HOST=${2:-$SOCKS_PROXY_HOST}
    SOCKS_PROXY_PORT=${3:-$SOCKS_PROXY_PORT}
    _set_gui_network_proxy -getsocksfirewallproxy -setsocksfirewallproxy $SOCKS_PROXY_HOST $SOCKS_PROXY_PORT 'socks' "$1"
}

nwguisocksproxyoff() {
    _unset_gui_network_proxy -getsocksfirewallproxy -setsocksfirewallproxystate -setsocksfirewallproxy 'socks' 
}

nwguihttpproxystatus() {
    _show_gui_network_proxy_status -getwebproxy 'http' "$NETWORK_INTERFACE"
}

nwguihttpproxyon() {
    HTTP_PROXY_HOST=${2:-$HTTP_PROXY_HOST}
    HTTP_PROXY_PORT=${3:-$HTTP_PROXY_PORT}
    _set_gui_network_proxy -getwebproxy -setwebproxy $HTTP_PROXY_HOST $HTTP_PROXY_PORT 'http' "$1"
}

nwguihttpproxyoff() {
    _unset_gui_network_proxy -getwebproxy -setwebproxystate -setwebproxy 'http'
}

nwguihttpsproxystatus() {
    _show_gui_network_proxy_status -getsecurewebproxy 'https' "$NETWORK_INTERFACE"
}

nwguihttpsproxyon() {
    HTTPS_PROXY_HOST=${2:-$HTTPS_PROXY_HOST}
    HTTPS_PROXY_PORT=${3:-$HTTPS_PROXY_PORT}
    _set_gui_network_proxy -getsecurewebproxy -setsecurewebproxy $HTTPS_PROXY_HOST $HTTPS_PROXY_PORT 'https' "$1"
}

nwguihttpsproxyoff() {
    _unset_gui_network_proxy -getsecurewebproxy -setsecurewebproxystate -setsecurewebproxy 'https'
}

# ################################## Terminal proxy #####################################

_is_terminal_network_proxy_on() {
    local PROXY_ENV_NAME=${1:?'Terminal proxy environment variable must be specify explicitly'}
    if eval "[ -n \"\${$PROXY_ENV_NAME}\" ]"; then
        return 0
    else
        return 1
    fi
}

_show_terminal_network_proxy_status() {
    if _is_terminal_network_proxy_on "$1"; then
        eval "echo \"terminal network [$2] proxy is already set on [\${$1}] ✅ \""
    else
        echo "terminal network [$2] proxy is not set ❌ "
    fi
}

_set_terminal_network_proxy() {
    if _is_terminal_network_proxy_on "$1"; then
        eval "echo \"terminal network [$4] proxy is already set on [\${$1}] ✅ \""
        return 0
    fi

    if ! _is_rust_ss_client_run; then
        _start_rust_ss_client
    fi

    export $1=$4://$2:$3
    eval "echo \"set terminal network [$4] proxy on [\${$1}] success! ✅ \""
}

_unset_terminal_network_proxy() {
    if ! _is_terminal_network_proxy_on "$1"; then
        echo "terminal network [$2] proxy is not set ❌ "
        return 0
    fi

    unset $1
    echo "unset terminal network [$2] proxy success! ✅ "
}

nwterminalsocksproxystatus() {
    _show_terminal_network_proxy_status 'ALL_PROXY' 'socks5'
}

# (1) 设置 socks5 代理时，ALL_PROXY 环境变量需大写
# (2) 不是所有程序都支持 ALL_PROXY 环境变量，例：curl 命令可能支持，但 wget 命令可能不支持，
#     这时可以设置下 http_proxy 和 https_proxy 环境变量试试
nwterminalsocksproxyon() {
    _set_terminal_network_proxy 'ALL_PROXY' "$SOCKS_PROXY_HOST" "$SOCKS_PROXY_PORT" 'socks5'
}

nwterminalsocksproxyoff() {
    _unset_terminal_network_proxy 'ALL_PROXY' 'socks5'
}

# 设置 http、https 代理时，http_proxy、https_proxy 环境变量在 mac 终端中只能小写(无论 shell 是 zsh、bash 还是其它的)
nwterminalhttpproxystatus() {
    _show_terminal_network_proxy_status 'http_proxy' 'http'
}

nwterminalhttpproxyon() {
    _set_terminal_network_proxy 'http_proxy' "$HTTP_PROXY_HOST" "$HTTP_PROXY_PORT" 'http'
}

nwterminalhttpproxyoff() {
    _unset_terminal_network_proxy 'http_proxy' 'http'
}

nwterminalhttpsproxystatus() {
    _show_terminal_network_proxy_status 'https_proxy' 'https'
}


nwterminalhttpsproxyon() {
    _set_terminal_network_proxy 'https_proxy' "$HTTPS_PROXY_HOST" "$HTTPS_PROXY_PORT" 'https'
}

nwterminalhttpsproxyoff() {
    _unset_terminal_network_proxy 'https_proxy' 'https'
}
