mysql_cfg() {
    local HOST=192.168.1.200
    local PORT=3306
    local USER=root
    local PWD=Ljx123456!
    local DB=iron_mes
    echo "mysql --default-character-set=utf8 -h ${HOST} -P ${PORT} -u${USER} -p${PWD} ${DB}"
}

mysqlconnect() {
    local ret=$(mysql_cfg)
    eval ${ret}
}

mysqlsql() {
    local ret=$(mysql_cfg)
    eval "${ret} -e '${1} \G'"
}

# 查看字段注释等信息
mysqlfileddesc() {
    mysqlsql "SHOW FULL COLUMNS FROM ${1} \G"
}

# 查看表注释、引擎等信息
mysqltabledesc() {
    mysqlsql "SHOW TABLE STATUS WHERE Name='${1}' \G"
}