_get_cfg_connect_sql() {
    local HOST=10.13.164.47
    local PORT=3306
    local USER=root
    local PWD=Ljx123456!
    local DB=ims_c673
    _get_connect_sql $HOST $PORT $USER $PWD $DB
}

_get_connect_sql() {
    echo "MYSQL_PWD=$4 mysql --default-character-set=utf8 -h $1 -P $2 -u $3 $5"
}

mysqlconnect2() {
    eval $(mysqlgetconnectsql $1 $2 $3 $4 $5)
}

mysqlsql() {
    eval "$(_get_cfg_connect_sql) -e \"${1}\""
}

# 查看指定表中所有字段注释等信息
mysqldesctablefields() {
    mysqlsql "SHOW FULL COLUMNS FROM ${1} \G"
}

# 查看表注释、引擎等信息
mysqldesctablemore() {
    mysqlsql "SHOW TABLE STATUS WHERE Name='${1}' \G"
}

mysqldesctable() {
    mysqlsql "DESC $1"
}

mysqlshowcreatetable() {
    mysqlsql "SHOW CREATE TABLE ${1}"
}

mysqlshowcustomfunctions() {
    mysqlsql "
    SELECT
        ROUTINE_NAME
       ,CREATED
    FROM information_schema.routines 
    WHERE ROUTINE_TYPE = 'FUNCTION'
    AND DEFINER NOT LIKE '%mysql%'"
}

mysqlshowcustomprocedures() {
    mysqlsql "
    SELECT
        ROUTINE_NAME
       ,CREATED
    FROM information_schema.routines 
    WHERE ROUTINE_TYPE = 'PROCEDURE'
    AND DEFINER NOT LIKE '%mysql%'"
}

mysqlshowcustomtrigs() {
    mysqlsql "SHOW TRIGGERS \G"
}

mysqlshowtablesize() {
    local SIZE_BYTE="DATA_LENGTH + INDEX_LENGTH"
    local QUERY_SQL="SELECT
                         TABLE_NAME 'Table'
                        ,ROUND(($SIZE_BYTE)/1024, 2) 'Size(KB)'
                     FROM information_schema.TABLES
                     WHERE TABLE_SCHEMA = '$1'"
    if [ ! $2 ]; then
        QUERY_SQL="$QUERY_SQL ORDER BY $SIZE_BYTE DESC"
    else
        QUERY_SQL="$QUERY_SQL AND TABLE_NAME = '$2'"
    fi
    mysqlsql "$QUERY_SQL"
}
