#!/bin/bash

source $SRC/lib/functions.sh

TEST_TITLE="2.4Ghz"
TEST_ICON="<img width=20 src=https://raw.githubusercontent.com/armbian/autotests/master/icons/wifi.png>"
TEST_SKIP="true"
[[ $DRY_RUN == true ]] && return 0

display_alert "$(basename $BASH_SOURCE)" "$(date  +%R:%S)" "info"

# remember which is default connection - to cover up corner cases with wlan connected devices only
# others are removed when iperf is finished
KEEPDEVICE=$(remote_exec "ls -1 /etc/NetworkManager/system-connections")

readarray -t array < <(get_device "^[wr].*" "")

for u in "${array[@]}"
do
	display_alert "Connecting ... " "$u" "info"
	GETUUID=$(remote_exec "nmcli -f UUID,DEVICE c show --active | grep $u | awk '{print \$1}'")
	[[ -n $GETUUID && ${#array[@]} -gt 1 ]] && remote_exec "nmcli con down $GETUUID &>/dev/null" # go down and
	[[ -n $GETUUID && ${#array[@]} -gt 1 ]] && remote_exec "nmcli c del $GETUUID &>/dev/null" # delete if previous defined
	output=$(remote_exec "nmcli c add type wifi con-name $u ifname $u ssid ${WLAN_ID_24}")
	output=$?
	# retry once just in case
	[[ $? -ne 0 ]] && sleep 2 && remote_exec "nmcli c add type wifi con-name $u ifname $u ssid ${WLAN_ID_24}" >> ${SRC}/logs/${USER_HOST}.txt 2>&1 && output=$?	
	remote_exec "nmcli con modify $u wifi-sec.key-mgmt wpa-psk" >> ${SRC}/logs/${USER_HOST}.txt 2>&1
	remote_exec "nmcli con modify $u wifi-sec.psk ${WLAN_PASS_24}" >> ${SRC}/logs/${USER_HOST}.txt 2>&1
	remote_exec "nmcli con up $u" >> ${SRC}/logs/${USER_HOST}.txt 2>&1
	[[ $? -ne 0 && ${output} -eq 0 ]] && display_alert "Can't connect to ${WLAN_ID_24}" "$u" "wrn"
done
sleep 3
