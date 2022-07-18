sqlserver_sql() {
    local SERVER=140.143.97.87
    local USER=sa
    local PASSWORD=Innov6-2-1
    local DB=WIMSFX11
    local Y=30
    cmd="sqlcmd -S ${SERVER} -U ${USER} -P ${PASSWORD} -y ${Y} -Y ${Y} -d ${DB}  -Q \"${1}\""
    #echo ${cmd}
    eval ${cmd}
}

sqlserver_dbs() {
    sqlserver_sql "SELECT name FROM sys.databases ORDER BY name"
}

sqlserver_tables() {
    sqlserver_sql "SELECT name FROM sys.objects WHERE type = 'U' ORDER BY name"
}

sqlserver_desc() {
    sqlserver_sql "SELECT 
                        t1.column_name Field,
                        (t1.data_type + '(' + CAST(t2.length AS VARCHAR(10)) + ')') Type,
                        t1.is_nullable [Null],
                        t1.column_default [Default],
                        t3.value [Remark]
                        FROM information_schema.columns t1
                        LEFT JOIN syscolumns t2 ON t1.column_name = t2.name
                        LEFT JOIN sys.extended_properties t3 ON t2.colid = t3.minor_id AND t3.major_id = object_id('${1}')
                        WHERE t1.table_name = '${1}'
                        AND t2.id = object_id('${1}')"
}

sqlserver_primary_key() {
    sqlserver_sql "SELECT 
                        table_name [Table], 
                        column_name [Pri] 
                        FROM information_schema.key_column_usage 
                        WHERE table_name = '${1}'"
}

sqlserver_topn() {
    sqlserver_sql "SELECT TOP ${1} * FROM ${2}"
}

sqlserver_add_cmt() {
    sqlserver_sql "EXEC sp_addextendedproperty
                        @name = N'MS_Description', @value = '${3}',
                        @level0type = N'Schema', @level0name = 'dbo',
                        @level1type = N'Table',  @level1name = '${1}',
                        @level2type = N'Column', @level2name = '${2}'"
}

sqlserver_update_cmt() {
    sqlserver_sql "EXEC sp_updateextendedproperty
                        @name = N'MS_Description', @value = '${3}',
                        @level0type = N'Schema', @level0name = 'dbo',
                        @level1type = N'Table',  @level1name = '${1}',
                        @level2type = N'Column', @level2name = '${2}'"
}

sqlserver_rm_cmt() {
    sqlserver_sql "EXEC sp_dropextendedproperty
                        @name = N'MS_Description',
                        @level0type = N'Schema', @level0name = 'dbo',
                        @level1type = N'Table',  @level1name = '${1}',
                        @level2type = N'Column', @level2name = '${2}'"
}
