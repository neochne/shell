mac_battery() {
    ioreg -rn AppleSmartBattery | grep -i "MaxCapacity\|Designcapacity"
}
