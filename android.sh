android_get_apk_info(){
    aapt dump badging ${1}
}

android_log_clear(){
    echo "log clear..."
    adb logcat -c
    echo "done"
}

android_log_e(){
    adb logcat "*:E"
}

android_log_s(){
    log_clear
    adb logcat -s ${1}
}

android_log_e_by_pkg() {
    adb logcat "*:E" | awk '$8~/'"${1}"'/ || $7~/Caused/ {print $0}'
}

android_build_shared_so() {
    cmake \
    -B output/ \
    -D CMAKE_LIBRARY_OUTPUT_DIRECTORY=armeabi-v7a \
    -D ANDROID_ABI=armeabi-v7a \
    -D ANDROID_NDK=/Users/sharp/sdk/android-sdk-macosx/ndk/23.0.7599858 \
    -D CMAKE_TOOLCHAIN_FILE=/Users/sharp/sdk/android-sdk-macosx/ndk/23.0.7599858/build/cmake/android-legacy.toolchain.cmake \
    .
}