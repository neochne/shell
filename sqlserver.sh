sqlserver_cfg() {
    local HOST=140.143.97.87
    local USER=sa
    local PWD=Innov6-2-1
    local DB=WIMSFX11
    echo "-S ${HOST} -U ${USER} -P ${PWD} -d ${DB}"
}

sqlserverconnectsqlcmd() {
    local ret=$(sqlserver_cfg)
    eval "sqlcmd ${ret}"
}

sqlserverconnectmssql() {
    local ret=$(sqlserver_cfg)
    eval "mssql-cli ${ret}"
}

sqlserversql() {
    local ret=$(sqlserver_cfg)
    eval "sqlcmd ${ret} -y 25 -Y 25 -Q \"${1}\""
}

sqlserverdbs() {
    sqlserversql "SELECT name FROM sys.databases ORDER BY name"
}

sqlservertables() {
    sqlserversql "SELECT name FROM sys.objects WHERE type = 'U' ORDER BY name"
}

sqlserverdesc() {
    sqlserversql "SELECT 
                  t1.column_name Field,
                  (t1.data_type + '(' + CAST(t2.length AS VARCHAR(10)) + ')') Type,
                  t1.is_nullable [Null],
                  t1.column_default [Default],
                  t3.value [Comment],
                  t4.value [Table Comment],
                  t5.type [Table Type]
                  FROM information_schema.columns t1
                  LEFT JOIN syscolumns t2 ON t1.column_name = t2.name
                  LEFT JOIN sys.extended_properties t3 ON t2.colid = t3.minor_id AND t3.major_id = object_id('${1}')
                  LEFT JOIN sys.extended_properties t4 ON t4.major_id = object_id('${1}') AND t4.minor_id = 0 AND t4.name = 'MS_Description'
                  LEFT JOIN sysobjects t5 ON t5.id = object_id('${1}')
                  WHERE t1.table_name = '${1}'
                  AND t2.id = object_id('${1}')"
}

sqlserverprimarykey() {
    sqlserversql "SELECT 
                  table_name [Table], 
                  column_name [Pri] 
                  FROM information_schema.key_column_usage 
                  WHERE table_name = '${1}'"
}

sqlservertopn() {
    sqlserversql "SELECT TOP ${1} * FROM ${2}"
}

sqlserveraddcmt() {
    if [ -z "${3}" ]; then
        sqlserversql "EXEC sp_addextendedproperty
                      @name = N'MS_Description', @value = '${2}',
                      @level0type = N'Schema', @level0name = 'dbo',
                      @level1type = N'Table',  @level1name = '${1}'"
    else 
        sqlserversql "EXEC sp_addextendedproperty
                      @name = N'MS_Description', @value = '${3}',
                      @level0type = N'Schema', @level0name = 'dbo',
                      @level1type = N'Table',  @level1name = '${1}',
                      @level2type = N'Column', @level2name = '${2}'"
    fi
}

sqlserverupdatecmt() {
    if [ -z "${3}" ]; then
        sqlserversql "EXEC sp_updateextendedproperty
                      @name = N'MS_Description', @value = '${2}',
                      @level0type = N'Schema', @level0name = 'dbo',
                      @level1type = N'Table',  @level1name = '${1}'"
    else
        sqlserversql "EXEC sp_updateextendedproperty
                      @name = N'MS_Description', @value = '${3}',
                      @level0type = N'Schema', @level0name = 'dbo',
                      @level1type = N'Table',  @level1name = '${1}',
                      @level2type = N'Column', @level2name = '${2}'"
    fi
}

sqlserverrmcmt() {
    if [ -z "${2}" ]; then
        sqlserversql "EXEC sp_dropextendedproperty
                      @name = N'MS_Description',
                      @level0type = N'Schema', @level0name = 'dbo',
                      @level1type = N'Table',  @level1name = '${1}'"
    else
        sqlserversql "EXEC sp_dropextendedproperty
                      @name = N'MS_Description',
                      @level0type = N'Schema', @level0name = 'dbo',
                      @level1type = N'Table',  @level1name = '${1}',
                      @level2type = N'Column', @level2name = '${2}'"
    fi
}
