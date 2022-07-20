androidgetapkinfo(){
    aapt dump badging ${1}
}

androidlogclear(){
    echo "log clear..."
    adb logcat -c
    echo "done"
}

androidloge(){
    adb logcat "*:E"
}

androidlogs(){
    log_clear
    adb logcat -s ${1}
}

androidlogebypkg() {
    adb logcat "*:E" | awk '$8~/'"${1}"'/ || $7~/Caused/ {print $0}'
}

androidbuildsharedso() {
    cmake \
    -B output/ \
    -D CMAKE_LIBRARY_OUTPUT_DIRECTORY=armeabi-v7a \
    -D ANDROID_ABI=armeabi-v7a \
    -D ANDROID_NDK=/Users/sharp/sdk/android-sdk-macosx/ndk/23.0.7599858 \
    -D CMAKE_TOOLCHAIN_FILE=/Users/sharp/sdk/android-sdk-macosx/ndk/23.0.7599858/build/cmake/android-legacy.toolchain.cmake \
    .
}