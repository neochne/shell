svnstdelete() {
    svn st | awk '$1~/!/ {print $0}'
}
