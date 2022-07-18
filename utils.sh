util_compr() {
    if [ ${1} = ${2} ]
    then # 必须换行，不换行需要在 if 条件后加 ; 号
        echo "true"
    else
        echo "false"
    fi
}

util_upper() {
    echo ${1} | tr '[:lower:]' '[:upper:]'
}

util_lower() {
    echo ${1} | tr '[:upper:]' '[:lower:]'
}

util_len() {
    echo ${#1} 
}
