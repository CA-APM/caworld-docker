#!/bin/sh
#
# dockerAgentCtrl.sh
# Control script for running the APM Docker Agent
# as a Unix service via an easy-to-use command line interface.
# Usage:
# dockerAgentCtrl.sh start
# dockerAgentCtrl.sh status
# dockerAgentCtrl.sh stop
# dockerAgentCtrl.sh help
#
# With specifying memory values:
# dockerAgentCtrl.sh start 64 1024
#
# The exit codes returned are:
#	0 - operation completed successfully
#	1 -
#	2 - usage error
#	3 - dockerAgent could not be started
#	4 - dockerAgent could not be stopped
#	8 - configuration syntax error
#
# When multiple arguments are given, only the error from the _last_
# argument is reported.
# Run "dockerAgentCtrl.sh help" for usage info

# |||||||||||||||||||| START CONFIGURATION SECTION  ||||||||||||||||||||
# Set the home directory if it is unset.
# Different OSes require different test statements
ERROR=0
THIS_OS=`uname -a | awk '{print $1}'`
case $THIS_OS in HP-UX)
    if ! [ "$WILYHOME" ] ; then
        WILYHOME="`pwd`"; export WILYHOME
    fi
    ;;
*)
    if [ -z "$WILYHOME" ]; then
        WILYHOME="`pwd`"; export WILYHOME
    fi
    ;;
esac
# The logfile
mkdir -p "${WILYHOME}/logs"
LOGFILE="${WILYHOME}/logs/dockerAgent.log"
# the path to your PID file
PIDFILE="${WILYHOME}/dockerAgent.pid"


# changes for passing heap values in arguments
MIN_HEAP_VAL_IN_MB=64
MAX_HEAP_VAL_IN_MB=512

MIN_ARG_PRESENT=true
if [ -z "$2" ]
  then
    MIN_ARG_PRESENT=false
fi

MAX_ARG_PRESENT=true
if [ -z "$3" ]
  then
    MAX_ARG_PRESENT=false
fi

if  $MIN_ARG_PRESENT == true
   then
   	#checking whether the input is a number
   	echo $2 | grep "[^0-9]" > /dev/null 2>&1
   	if [ "$?" -eq "0" ]; then  # If the grep found something other than 0-9  # then it's not an integer.
   	  echo "Invalid value: $2. Please specify a numeric value for minimum java heap memory"
   	  ERROR=2
   	else
   	  if [ $2 -gt ${MIN_HEAP_VAL_IN_MB} ]
    	    then
    	      MIN_HEAP_VAL_IN_MB=$2
    	      #echo Min Heap is: $MIN_HEAP_VAL_IN_MB
    	  fi
    	fi
fi

if  $MAX_ARG_PRESENT == true
   then
   	#checking whether the input is a number
   	echo $3 | grep "[^0-9]" > /dev/null 2>&1
   	if [ "$?" -eq "0" ]; then  # If the grep found something other than 0-9  # then it's not an integer.
   	  echo "Invalid value: $3. Please specify a numeric value for maximum java heap memory"
   	  ERROR=2
   	else
       	  if [ $3 -ge ${MIN_HEAP_VAL_IN_MB} ]
            then
              MAX_HEAP_VAL_IN_MB=$3
              #echo Min Heap is: $MIN_HEAP_VAL_IN_MB,          	Min Heap is: $MAX_HEAP_VAL_IN_MB
    	  fi
    	fi
fi

if [ ${MIN_HEAP_VAL_IN_MB} -gt ${MAX_HEAP_VAL_IN_MB} ]
  then
    MAX_HEAP_VAL_IN_MB=$MIN_HEAP_VAL_IN_MB
fi

# set up class path
#
JAVA_HOME="${WILYHOME}/jre/bin"
DOCKERMONITOR="${WILYHOME}/lib/DockerMonitor.jar"

# the command to start the dockerAgent

echo "MIN HEAP Size: $MIN_HEAP_VAL_IN_MB"
echo "MAX HEAP Size: $MAX_HEAP_VAL_IN_MB"

dockerAgentCmd="java -Xms${MIN_HEAP_VAL_IN_MB}m -Xmx${MAX_HEAP_VAL_IN_MB}m -Ddata.file=./config/metriclist.json -Dcom.wily.introscope.agentProfile=./config/docker.properties -jar ${DOCKERMONITOR}"
#echo $dockerAgentCmd
# -Xdebug -Xrunjdwp:transport=dt_socket,address=8001,server=y,suspend=y
# ||||||||||||||||||||   END CONFIGURATION SECTION  ||||||||||||||||||||

cd "${WILYHOME}"

ARGV="$@"
if [ "x$ARGV" = "x" ] ; then
    ARGS="help"
fi

for ARG_RAW in $@ $ARGS
do
    # check for pidfile
    if [ -f "$PIDFILE" ] ; then
	PID=`cat "$PIDFILE"`
	if [ "x$PID" != "x" ] && kill -0 $PID 2>/dev/null ; then
	    STATUS="dockerAgent (pid $PID) running"
	    RUNNING=1
	else
	    STATUS="dockerAgent (pid $PID?) not running"
	    RUNNING=0
	fi
    else
	STATUS="dockerAgent (no pid file) not running"
	RUNNING=0
    fi

    if [ $ERROR -eq 2 ]
      then
      	ARG="help"
      	#echo  VALUE CHANGED to help: $ARG
      else
      	ARG=${ARG_RAW}
      	#echo  VALUE CHANGED to actual: $ARG
    fi

    case $ARG in
      status)
    	if [ $RUNNING -eq 1 ]; then
    		echo "$0 $ARG:  Agent is running"
    	else
    		echo "$0 $ARG:  Agent is stopped"
    	fi
    	;;
    start)
    	if [ $RUNNING -eq 1 ]; then
	    echo "$0 $ARG: dockerAgent (pid $PID) already running"
	    continue
	fi
	nohup $dockerAgentCmd >> "$LOGFILE" 2>&1 &
	if [ "x$!" != "x" ] ; then
	    echo "$!" > "$PIDFILE"
	    echo "$0 $ARG: dockerAgent started"
	    break;
	else
	    echo "$0 $ARG: dockerAgent could not be started"
	    ERROR=3
	fi
	;;
    stop)
	if [ $RUNNING -eq 0 ]; then
	    echo "$0 $ARG: $STATUS"
	    continue
	fi
	if kill $PID ; then
	    rm "$PIDFILE"
	    echo "$0 $ARG: dockerAgent stopped"
	else
	    echo "$0 $ARG: dockerAgent could not be stopped"
	    ERROR=4
	fi
	;;
    *)
	echo "usage: $0 (start|stop|status|help) [min java heap] [max java heap] EMHOSTNAME EMPORT"
	cat <<EOF
where
     start      		- start dockerAgent
     stop     	 		- stop dockerAgent
     status    			- status of dockerAgent
     help      			- this screen
     min java heap    		- minimum java heap memory in MB, default is 16
     max java heap		- maximum java heap memory in MB, default is 256
EOF
	ERROR=2
    ;;

    esac
    break
done

exit $ERROR
