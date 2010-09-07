#!/bin/bash

set -e

CONF_PATH=/etc/default/hh-log-analyzer

if [ -f $CONF_PATH ] ; then
	. $CONF_PATH
fi

cat $LOG_PATH | $CALC_WEIGHTS_SCRIPT_PATH $1 $2

