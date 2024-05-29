svnst() {
    svn st | awk '$1~/'"$1"'/ {print $0}'
}
