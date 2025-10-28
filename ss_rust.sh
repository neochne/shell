RUST_SS_JSON_CFG_FILE=/Users/sharp/sdk/ss/ss_rust/cfg.json
RUST_SS_PID_FILE=/Users/sharp/sdk/ss/ss_rust/ss_rust_client.pid

is_rust_ss_client_run() {
    if test -f "$RUST_SS_PID_FILE"; then
        pid=`cat $RUST_SS_PID_FILE`
        ps -p $pid > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            return 0
        else
           rm -fr $RUST_SS_PID_FILE
           return 1
        fi
    else
        pid=`pgrep sslocal`
        if [ -n "$pid" ]; then
            kill -9 $pid
        fi
        return 1
    fi
}

show_rust_ss_client_status() {
    if is_rust_ss_client_run; then
        pid=`cat $RUST_SS_PID_FILE`
        echo "rust ss client is already run on [$pid] ✅ "
    else
        echo "rust ss client is not run ❌ "
    fi
}

rustssclientstatus() {
    show_rust_ss_client_status
}

start_rust_ss_client() {
    if is_rust_ss_client_run; then
        pid=`cat $RUST_SS_PID_FILE`
        echo "rust ss client is already run on [$pid] ✅ "
        return 0
    fi

    /Users/sharp/sdk/ss/ss_rust/sslocal -c $RUST_SS_JSON_CFG_FILE --daemonize-pid $RUST_SS_PID_FILE

    pid=`cat $RUST_SS_PID_FILE`
    echo "start rust ss client on [$pid] success! ✅ "
}

rustssclientstart() {
    start_rust_ss_client
}

stop_rust_ss_client() {
    if ! is_rust_ss_client_run; then
        echo "rust ss client is not run ❌ "
        return 0
    fi

    cat $RUST_SS_PID_FILE | xargs kill -9
    pid=`cat $RUST_SS_PID_FILE`
    rm -fr $RUST_SS_PID_FILE

    echo "stop rust ss client on [$pid] success! ✅ "
}

rustssclientstop() {
    stop_rust_ss_client
}
