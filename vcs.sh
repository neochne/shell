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

# 建议先删除不需要版本控制的目录及文件（见上面的 remove_xxx 函数），然后用一次 'svn import' 命令导入项目，不然多次使用 'svn import' 会产生多条提交信息
svn_import_as_native_android_project() {
    # 1. Please configure variables first
    local LOCAL_PATH=~/temp/E16AssJump
    local REMOTE_URL="https://140.143.97.87/svn/ChangAn1Assembly/android/E16AssJump"
    local MODULES=(app)

    # 2. Import root files
    svn import ${LOCAL_PATH}/gradle/ ${REMOTE_URL}/gradle/ -m "import project gradle/ dir"
    svn import ${LOCAL_PATH}/gradlew ${REMOTE_URL}/gradlew -m "import project gradlew file"
    svn import ${LOCAL_PATH}/gradlew.bat ${REMOTE_URL}/gradlew.bat -m "import project gradlew.bat file"
    svn import ${LOCAL_PATH}/build.gradle.kts ${REMOTE_URL}/build.gradle.kts -m "import project build.gradle file"
    svn import ${LOCAL_PATH}/settings.gradle.kts ${REMOTE_URL}/settings.gradle.kts -m "import project settings.gradle file"
    svn import ${LOCAL_PATH}/gradle.properties ${REMOTE_URL}/gradle.properties -m "import project gradle.properties file"

    # 3. Import modules
    for module in ${MODULES[*]}
    do
        svn import ${LOCAL_PATH}/${module}/libs ${REMOTE_URL}/${module}/libs -m "import ${module} module lib/ dir"
        svn import ${LOCAL_PATH}/${module}/src ${REMOTE_URL}/${module}/src -m "import ${module} moduele src/ dir"
        svn import ${LOCAL_PATH}/${module}/build.gradle.kts ${REMOTE_URL}/${module}/build.gradle.kts -m "import ${module} module build.gradle file"
    done

    echo "\n\nimport complete!"
}

svn_import_as_flutter_project() {
    # 1. Please configure variables first
    local LOCAL_PATH=~/wrk/android/as/flutter_demo
    local REMOTE_URL="svn://192.168.50.4:1982/code/claim/mcms/mcms_moblie/product/trunck/mcms-android/flutter_demo"

    # 2. Import project
    svn import ${LOCAL_PATH}/pubspec.lock ${REMOTE_URL}/pubspec.lock -m "import project pubspec.lock file"
    svn import ${LOCAL_PATH}/pubspec.yaml ${REMOTE_URL}/pubspec.yaml -m "import project pubspec.yaml file"
    svn import ${LOCAL_PATH}/lib/ ${REMOTE_URL}/lib/ -m "import project pubspec lib/ dir"
    svn import ${LOCAL_PATH}/images/ ${REMOTE_URL}/images/ -m "import project images/ dir"

    # 3. Import android module
    svn import ${LOCAL_PATH}/android/app/src ${REMOTE_URL}/android/app/src -m "import android module src/ dir"
    svn import ${LOCAL_PATH}/android/app/build.gradle ${REMOTE_URL}/android/app/build.gradle -m "import android module build.gradle file"
    svn import ${LOCAL_PATH}/android/gradle/ ${REMOTE_URL}/android/gradle/ -m "import android module gradle/ dir"
    svn import ${LOCAL_PATH}/android/build.gradle ${REMOTE_URL}/android/build.gradle -m "import android module build.gradle file"
    svn import ${LOCAL_PATH}/android/gradle.properties ${REMOTE_URL}/android/gradle.properties -m "import android module gradle.properties file"
    svn import ${LOCAL_PATH}/android/settings.gradle ${REMOTE_URL}/android/settings.gradle -m "import android module settings.gradle file"
    svn import ${LOCAL_PATH}/android/gradlew ${REMOTE_URL}/android/gradlew -m "import android module gradlew file"
    svn import ${LOCAL_PATH}/android/gradlew.bat ${REMOTE_URL}/android/gradlew.bat -m "import android module gradlew.bat file"

    # 4. Import ios module
    svn import ${LOCAL_PATH}/ios/Flutter/AppFrameworkInfo.plist ${REMOTE_URL}/ios/Flutter/AppFrameworkInfo.plist -m "import ios module AppFrameworkInfo.plist file"
    svn import ${LOCAL_PATH}/ios/Flutter/Debug.xcconfig ${REMOTE_URL}/ios/Flutter/Debug.xcconfig -m "import ios module Debug.xcconfig file"
    svn import ${LOCAL_PATH}/ios/Flutter/Release.xcconfig ${REMOTE_URL}/ios/Flutter/Release.xcconfig -m "import ios module Release.xcconfig file"
    svn import ${LOCAL_PATH}/ios/Runner/ ${REMOTE_URL}/ios/Runner/ -m "import ios module Runner/ dir"
    svn import ${LOCAL_PATH}/ios/Runner.xcodeproj/ ${REMOTE_URL}/ios/Runner.xcodeproj/ -m "import ios module Runner.xcodeproj/ dir"
    svn import ${LOCAL_PATH}/ios/Runner.xcworkspace/ ${REMOTE_URL}/ios/Runner.xcworkspace/ -m "import ios module Runner.xcworkspace/ dir"
    svn import ${LOCAL_PATH}/ios/Podfile ${REMOTE_URL}/ios/Podfile -m "import ios module Podfile file"
    svn import ${LOCAL_PATH}/ios/Podfile.lock ${REMOTE_URL}/ios/Podfile.lock -m "import ios module /Podfile.lock file"

    echo "\n\nimport complete!"
}
