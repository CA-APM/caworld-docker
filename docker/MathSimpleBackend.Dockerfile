FROM tomcat:8-jre8

MAINTAINER guenter.grossberger@ca.com

ENV WILY_HOME=$CATALINA_HOME/wily
ENV AGENT_TAR=IntroscopeAgent.tgz
ENV EM_HOST=em
ENV EM_PORT=5001
ENV AGENT_NAME=MathSimpleBackend
ENV HEAP=2048m

# install agent
ADD $AGENT_TAR $CATALINA_HOME

# install mathapp application
COPY MathSimpleBackend.war $CATALINA_HOME/webapps/

# configure CA APM java agent
COPY setenv.sh $CATALINA_HOME/bin/setenv.sh
