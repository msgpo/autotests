#!/bin/bash
source $SRC/lib/functions.sh

TEST_TITLE="AES-128"
TEST_ICON="<img width=20 src=https://raw.githubusercontent.com/armbian/autotests/master/icons/ssl.png>"
[[ $DRY_RUN == true ]] && return 0

display_alert "$(basename $BASH_SOURCE)" "${BOARD_NAME} @ $(mask_ip "$USER_HOST")" "info"

if [[ "$r" -le "${SBCBENCHPASS}" && -n "${AES128}" ]]; then

	TEST_OUTPUT=${AES128}
	display_alert "OpenSSL bench" "AES-128 16byte: ${AES128}" "info"
	
	else

	TEST_OUTPUT="<img width=20 src=https://raw.githubusercontent.com/armbian/autotests/master/icons/na.png>"
	display_alert "OpenSSL bench" "No data" "wrn"

fi
