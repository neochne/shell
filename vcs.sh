vcs_import_as_native_android_project_to_svn() {
    # 1. Please configure variables first
    local LOCAL_PATH=~/wrk/android/as/ScanToUHF
    local REMOTE_URL="https://140.143.97.87/svn/C673Assembly/child/ScanToUHF"
    local MODULES=(app)

    # 2. Import root files
    svn import ${LOCAL_PATH}/gradle/ ${REMOTE_URL}/gradle/ -m "import project gradle/ dir"
    svn import ${LOCAL_PATH}/gradlew ${REMOTE_URL}/gradlew -m "import project gradlew file"
    svn import ${LOCAL_PATH}/gradlew.bat ${REMOTE_URL}/gradlew.bat -m "import project gradlew.bat file"
    svn import ${LOCAL_PATH}/build.gradle ${REMOTE_URL}/build.gradle -m "import project build.gradle file"
    svn import ${LOCAL_PATH}/settings.gradle ${REMOTE_URL}/settings.gradle -m "import project settings.gradle file"
    svn import ${LOCAL_PATH}/gradle.properties ${REMOTE_URL}/gradle.properties -m "import project gradle.properties file"

    # 3. Import modules
    for module in ${MODULES[*]}
    do
        svn import ${LOCAL_PATH}/${module}/libs ${REMOTE_URL}/${module}/libs -m "import ${module} module lib/ dir"
        svn import ${LOCAL_PATH}/${module}/src ${REMOTE_URL}/${module}/src -m "import ${module} moduele src/ dir"
        svn import ${LOCAL_PATH}/${module}/build.gradle ${REMOTE_URL}/${module}/build.gradle -m "import ${module} module build.gradle file"
    done

    echo "\n\nimport complete!"
}

vcs_import_as_flutter_project_to_svn() {
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
