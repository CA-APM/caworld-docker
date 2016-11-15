FROM tomcat:8-jre8

MAINTAINER guenter.grossberger@ca.com

ENV WILY_HOME=$CATALINA_HOME/wily
ENV AGENT_TAR=IntroscopeAgent.tgz
ENV EM_HOST=em
ENV EM_PORT=5001
ENV AGENT_NAME=MathClient
ENV HEAP=2048m

# install agent
ADD $AGENT_TAR $CATALINA_HOME

# install mathapp application
COPY MathClient.war $CATALINA_HOME/webapps/
RUN cd webapps \
  && unzip -d MathClient MathClient.war \
  && sed -Ei "s/port=.*/port=8080/" $CATALINA_HOME/webapps/MathClient/WEB-INF/classes/mathapp.properties \
  && sed -Ei "s/host=.*/host=mathproxy/" $CATALINA_HOME/webapps/MathClient/WEB-INF/classes/mathapp.properties \
  && rm MathClient.war

COPY tomcat-users.xml $CATALINA_HOME/conf

# configure CA APM java agent
COPY setenv.sh $CATALINA_HOME/bin/setenv.sh
