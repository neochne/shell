utilcompr() {
    if [ ${1} = ${2} ]
    then # 必须换行，不换行需要在 if 条件后加 ; 号
        echo "true"
    else
        echo "false"
    fi
}

utilupper() {
    echo ${1} | tr '[:lower:]' '[:upper:]'
}

utillower() {
    echo ${1} | tr '[:upper:]' '[:lower:]'
}

utillen() {
    echo ${#1} 
}

utilless() {
    find . -name $1 | xargs less
}
