compr() {
    if [ ${1} = ${2} ]
    then # 必须换行，不换行需要在 if 条件后加 ; 号
        echo "true"
    else
        echo "false"
    fi
}

upper() {
    echo ${1} | tr '[:lower:]' '[:upper:]'
}

lower() {
    echo ${1} | tr '[:upper:]' '[:lower:]'
}

len() {
    echo ${#1} 
}

lessx() {
    # find $2 -name $1 | xargs less
    find $2 -name $1 -exec less {} +
}

grepx() {
    grep -lr $1 $2
}
