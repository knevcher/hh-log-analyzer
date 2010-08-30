#!/bin/bash

set -e

CONF_PATH=/etc/default/log_analyzer #/etc/default

if [ -f $CONF_PATH ] ; then
	. $CONF_PATH
fi

cat $LOG_PATH | $CALC_WEIGHTS_SCRIPT_PATH $PARSING_INTERVAL >> $STATISTIC_STORAGE_PATH

