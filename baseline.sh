#!/bin/sh
#

SCRIPT=mathapp-baseline
SCRIPT_DIR=scripts
LOG_DIR=.

JMETER_DIR=./apache-jmeter-3.0

if [ ! -e $JMETER_DIR ] ; then
    wget http://apache.claz.org/jmeter/binaries/apache-jmeter-3.0.tgz
    tar -xvzf apache-jmeter-3.0.tgz
fi

${JMETER_DIR}/bin/jmeter.sh -n -t ${SCRIPT_DIR}/${SCRIPT}.jmx -j ${LOG_DIR}/jmeter-${SCRIPT}.log 1>/dev/null &
# -l ${LOG_DIR}/${SCRIPT}.jtl
