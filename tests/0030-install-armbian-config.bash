#!/bin/bash

source $SRC/lib/functions.sh

display_alert "$(basename $BASH_SOURCE)" "$(date  +%R:%S)" "info"
sshpass -p ${PASS_ROOT} ssh ${USER_ROOT}@${HOST} "apt -y install armbian-config" | tee -a ${SRC}/logs/${HOST}.log | tee -a ${SRC}/logs/${HOST}.txt
