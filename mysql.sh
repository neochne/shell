mysql_cfg() {
    local HOST=192.168.1.200
    local PORT=3306
    local USER=root
    local PWD=Ljx123456!
    local DB=ims_c673
    echo "MYSQL_PWD=${PWD} mysql --default-character-set=utf8 -h ${HOST} -P ${PORT} -u${USER} ${DB}"
}

mysqlconnect() {
    eval $(mysql_cfg)
}

mysqlsql() {
    eval "$(mysql_cfg) -e \"${1}\""
}

# 查看指定表中所有字段注释等信息
mysqldesctablefields() {
    mysqlsql "SHOW FULL COLUMNS FROM ${1} \G"
}

# 查看表注释、引擎等信息
mysqldesctable() {
    mysqlsql "SHOW TABLE STATUS WHERE Name='${1}' \G"
}
