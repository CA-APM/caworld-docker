#!/bin/bash

# set EM host and port
sed -Ei "s/agentManager.url.1=localhost:5001/agentManager.url.1=$EM_HOST:$EM_PORT/" $WILY_HOME/core/config/IntroscopeAgent.profile

# now add the APM agent to Tomcat startup parameters
export CATALINA_OPTS="$CATALINA_OPTS -Xmx$HEAP -javaagent:$WILY_HOME/Agent.jar -Dcom.wily.introscope.agentProfile=$WILY_HOME/core/config/IntroscopeAgent.profile -Dcom.wily.introscope.agent.agentName=$AGENT_NAME $AGENT_HOSTNAME_ARG"
