#!/bin/bash

AGENT_FILES=IntroscopeAgent.tgz
MATH_CLIENT=MathClient.war

if [ ! -e $AGENT_FILES ] ; then
  echo "$AGENT_FILES is missing. Please download $AGENT_FILES from support.ca.com and place it in this directory."
fi

if [ ! -e $MATH_CLIENT ] ; then
  echo "$MATH_CLIENT is missing. Please download and build MathApp from https://github.com/hrahmed/mathapp-java and copy $MATH_CLIENT to this directory."
fi

sudo=sudo
unamestr=`uname`

#if [[ "$unamestr" == 'Darwin' ]]; then
	sudo=''
#fi

echo "Starting the build"
$sudo docker build -t mathapp_client .
