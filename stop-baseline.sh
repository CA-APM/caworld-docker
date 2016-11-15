#!/bin/sh

JMETER_DIR=./apache-jmeter-3.0

java -cp ${JMETER_DIR}/bin/ApacheJMeter.jar org.apache.jmeter.util.ShutdownClient StopTestNow "$@"
