aaptdumpapk(){
    aapt dump badging ${1}
}

adblogclear(){
    echo "log clear..."
    adb logcat -c
    echo "done"
}

adbloge(){
    adb logcat "*:E"
}

adblogs(){
    adblogclear
    adb logcat -s ${1}
}

adbloge4pkg() {
    adb logcat "*:E" | awk '$8~/'"${1}"'/ || $7~/Caused/ {print $0}'
}

adbshellprocess() {
    adb shell ps -A
}

adbshellgetprocessadj() {
    adb shell cat /proc/$1/oom_adj 
}

cmakesharedso() {
    cmake \
    -B output/ \
    -D CMAKE_LIBRARY_OUTPUT_DIRECTORY=armeabi-v7a \
    -D ANDROID_ABI=armeabi-v7a \
    -D ANDROID_NDK=/Users/sharp/sdk/android-sdk-macosx/ndk/23.0.7599858 \
    -D CMAKE_TOOLCHAIN_FILE=/Users/sharp/sdk/android-sdk-macosx/ndk/23.0.7599858/build/cmake/android-legacy.toolchain.cmake \
    .
}
