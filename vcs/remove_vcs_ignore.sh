_remove_vcs_ignores() {
    rm -fr $1
    echo "remove [$1] ok!"
}

remove_vcs_ignores_for_springboot_project() {
    if [ ! -n "$1" ] ;then
        echo "Please input springboot project abs path"
        return
    fi

    _remove_vcs_ignores $1/.idea
    _remove_vcs_ignores $1/.mvn
    _remove_vcs_ignores $1/.svn
    _remove_vcs_ignores $1/.git
    _remove_vcs_ignores $1/data
    _remove_vcs_ignores $1/logs
    _remove_vcs_ignores $1/logback
    _remove_vcs_ignores $1/target
}

remove_vcs_ignores_for_android_project() {
    if [ ! -n "$1" ] ;then
        echo "Please input android project abs path"
        return
    fi
    
    # 用正则删除时，忽略没有匹配到条件时报no matches found: /Users/sharp/temp/My/*.iml 警告问题
    setopt no_nomatch 
    _remove_vcs_ignores $1/.DS_Store
    _remove_vcs_ignores $1/.gitignore
    _remove_vcs_ignores $1/.gradle
    _remove_vcs_ignores $1/.idea
    _remove_vcs_ignores $1/.svn
    _remove_vcs_ignores $1/.git
    _remove_vcs_ignores $1/local.properties
    _remove_vcs_ignores $1/*.iml
}

remove_vcs_ignores_for_androidmodule_project() {
    if [ ! -n "$1" ] ;then
        echo "Please input android project module abs path"
        return
    fi
    
    _remove_vcs_ignores $1/.DS_Store
    _remove_vcs_ignores $1/.gitignore
    _remove_vcs_ignores $1/build
    _remove_vcs_ignores $1/src/androidTest
    _remove_vcs_ignores $1/src/test
    _remove_vcs_ignores $1/src/main/res/drawable
    _remove_vcs_ignores $1/src/main/res/mipmap-anydpi-v26
    _remove_vcs_ignores $1/src/main/res/mipmap-hdpi
    _remove_vcs_ignores $1/src/main/res/mipmap-mdpi
    _remove_vcs_ignores $1/src/main/res/mipmap-xhdpi
    _remove_vcs_ignores $1/src/main/res/mipmap-xxhdpi
    _remove_vcs_ignores $1/src/main/res/values-night
    _remove_vcs_ignores $1/src/main/res/xml
}
