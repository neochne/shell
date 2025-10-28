#NETWORK_SERVICE="USB 10/100/1000 LAN"
#NETWORK_SERVICE="Wi-Fi"
#NETWORK_SERVICE="MT65xx Preloader"
NETWORK_SERVICE="USB 10/100 LAN"
PROXY_HOST=127.0.0.1
PROXY_PORT=1086

# ################################## Network #####################################

list_all_network() {
    networksetup -listallnetworkservices
}

nwall() {
    list_all_network
}

# ################################## GUI socks proxy #####################################

is_gui_network_socks_proxy_on() {
    local NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"
    socks_state_details=$(networksetup -getsocksfirewallproxy "$NETWORK_SERVICE")
    if echo "$socks_state_details" | grep -q "Enabled: Yes"; then
        return 0
    else
        return 1
    fi
}

show_gui_network_socks_proxy_status() {
    local NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"
    echo "=== network [${NETWORK_SERVICE}] Status: ==="
    networksetup -getsocksfirewallproxy "$NETWORK_SERVICE"
    echo ""
    echo "=== network [${NETWORK_SERVICE}] Bypass: ==="
    networksetup -getproxybypassdomains "$NETWORK_SERVICE"
}

nwguissproxystatus() {
    show_gui_network_socks_proxy_status "$1"
}

set_gui_network_socks_proxy() {
    NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"
    PROXY_HOST=${2:-$PROXY_HOST}
    PROXY_PORT=${3:-$PROXY_PORT}

    if is_gui_network_socks_proxy_on $NETWORK_SERVICE; then
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

nwguissproxyon() {
    set_gui_network_socks_proxy "$1" "$2" "$3"
}

unset_gui_network_socks_proxy() {
    NETWORK_SERVICE="${1:-$NETWORK_SERVICE}"

    if ! is_gui_network_socks_proxy_on $NETWORK_SERVICE; then
        echo "network [$NETWORK_SERVICE] is not set gui socks proxy ❌ "
        return 0
    fi

    networksetup -setsocksfirewallproxystate "$NETWORK_SERVICE" off
    networksetup -setproxybypassdomains "$NETWORK_SERVICE" "Empty"

    echo "stop network [${NETWORK_SERVICE}] gui socks proxy success! ✅ "
}

nwguissproxyoff() {
    unset_gui_network_socks_proxy "$1"
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

nwterminalssproxystatus() {
    show_terminal_network_socks_proxy_status
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

nwterminalssproxyon() {
    set_terminal_network_socks_proxy "$1" "$2"
}

unset_terminal_network_socks_proxy() {
    if ! is_terminal_network_socks_proxy_on; then
        echo "terminal network socks proxy is not set ❌ "
        return 0
    fi

    unset ALL_PROXY
    echo "unset terminal network socks proxy success! ✅ "
}

nwterminalssproxyoff() {
    unset_terminal_network_socks_proxy
}
