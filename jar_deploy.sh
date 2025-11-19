_is_jar_pid_exists() {
    if [ -z "$1" ]; then
        echo 'Usage: _is_jar_pid_exists <JAR>'
        return 1
    fi

    local jar_pids=(`jarpids "$1"`)

    if [ ${#jar_pids[@]} -ne 0 ]; then
        return 0
    fi
    return 1
}

_print_jar_start_result() {
    if [ -z "$1" ]; then
        echo 'Usage: _print_jar_start_result <JAR>'
        return 1
    fi

    local max_wait=120
    local wait_time=2

    sleep 2

    while [ $wait_time -lt $max_wait ]; do
        if _is_jar_pid_exists "$1"; then
            echo "[$1] start ok! ✅ "
            return 0
        fi
        echo "starting... ($((wait_time + 1))/$max_wait s)"
        sleep 1
        ((wait_time++))
    done
    
    echo "[$1] start timeout ❌ "
    return 1 
}

jarpids() {
    if [ -z "$1" ]; then
        echo 'Usage: jarpids <JAR>'
        return 1
    fi

    #local jar_pids=(`ps -ef | grep "$1" | grep -v "grep" | awk '{print $2}'`)
    local jar_pids=(`pgrep -f "$1"`)

    echo "${jar_pids[@]}"
}

jarstop() {
    if [ -z "$1" ]; then
        echo 'Usage: jarstop <JAR>'
        return 1
    fi

    local jar_pids=(`jarpids "$1"`)

    if [ ${#jar_pids[@]} -eq 0 ]; then
        echo "[$1] not start ❌ "
        return 1
    fi

    for pid in "${jar_pids[@]}"; do
        if [ -n "$pid" ]; then
            kill -9 $pid
            echo "killed [$pid] ok! ✅ "
        fi
    done

    echo "[$1] stop ok! ✅ "
}

jarstartbg() {
    if [ -z "$1" ]; then
        echo 'Usage: jarstartbg <JAR> <PORT>'
        return 1
    fi

    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    echo "[$1] starting..."

    local JAVA_OPTS="-Xms1g \
    -Xmx1g \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=200 \
    -XX:InitiatingHeapOccupancyPercent=35 \
    -XX:+AlwaysPreTouch \
    -Dfile.encoding=UTF-8" 

    if [ -n "$2" ]; then
       JAVA_OPTS="$JAVA_OPTS -Dserver.port=$2"
    fi

    nohup java $JAVA_OPTS -jar "$1" &> /dev/null &

    _print_jar_start_result "$1"
}

jarstartbgc() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ] || [ -z "$5" ] || [ -z "$6" ]; then
        printf "%25s: %s\n" "Usage" "jarstartbgc <JAR> \\"
        printf "%25s: %s\n" "" "<NACOS_LOGS_PATH> \\"
        printf "%25s: %s\n" "" "<NACOS_SNAPSHOTS_PATH> \\"
        printf "%25s: %s\n" "" "<NACOS_CFG_NAMESPACE> \\"
        printf "%25s: %s\n" "" "<NACOS_SRV_NAMESPACE> \\"
        printf "%25s: %s\n" "" "<SENTINEL_LOGS_PATH>\\"
        printf "%25s: %s\n" "" "<PORT>"
        return
    fi

    export LANG=en_US.UTF-8
    export LC_ALL=en_US.UTF-8

    echo "---------------------------------------------------------------------------------"
    printf "%25s: %s\n" "JAR" "$1"
    printf "%25s: %s\n" "NACOS_LOGS_PATH" "$2"
    printf "%25s: %s\n" "NACOS_SNAPSHOTS_PATH" "$3"
    printf "%25s: %s\n" "NACOS_CFG_NAMESPACE" "$4"
    printf "%25s: %s\n" "NACOS_SRV_NAMESPACE" "$5"
    printf "%25s: %s\n" "SENTINEL_LOGS_PATH" "$6"
    printf "%25s: %s\n" "PORT" "$7"
    echo "---------------------------------------------------------------------------------"

    echo "starting..."

    local JAVA_OPTS="-Xms1g \
    -Xmx1g \
    -XX:+UseG1GC \
    -XX:MaxGCPauseMillis=200 \
    -XX:InitiatingHeapOccupancyPercent=35 \
    -XX:+AlwaysPreTouch \
    -Dfile.encoding=UTF-8 \
    -Dspring.cloud.nacos.config.namespace=$4 \
    -Dspring.cloud.nacos.discovery.namespace=$5 \
    -DJM.LOG.PATH=$2 \
    -DJM.SNAPSHOT.PATH=$3 \
    -Dcsp.sentinel.log.dir=$6" 

    if [ -n "$7" ]; then
       JAVA_OPTS="$JAVA_OPTS -Dserver.port=$7"
    fi

    nohup java ${JAVA_OPTS} -jar "$1" &> /dev/null &

    _print_jar_start_result "$1"
}
