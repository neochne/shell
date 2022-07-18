# 显示字段注释等额外信息
mysql_full_desc() {
    emysql "SHOW FULL COLUMNS FROM ${1} \G"
}

mysql_sql() {
    local SERVER=192.168.1.200
    local PORT=3306
    local USER=root
    local PWD=Ljx123456!
    local DB=iron_mes
    mysql \
    --default-character-set=utf8 \
    -h ${SERVER} \
    -P ${PORT} \
    -u${USER} \
    -p${PWD} \
    ${DB} \
    -e ${1}
}
