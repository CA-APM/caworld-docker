FROM tomcat:8-jre8

MAINTAINER guenter.grossberger@ca.com

ENV WILY_HOME=$CATALINA_HOME/wily
ENV AGENT_TAR=IntroscopeAgent.tgz
ENV EM_HOST=em
ENV EM_PORT=5001
ENV AGENT_NAME=MathClient
ENV HEAP=2048m

# install agent
ADD IntroscopeAgentFiles-NoInstaller${INTROSCOPE_VERSION}tomcat.unix.tar $CATALINA_HOME

# install mathapp application
ADD MathClient.war $CATALINA_HOME/webapps/
RUN sed -Ei "s/port=.*/port=8080/" $CATALINA_HOME/webapps/MathClient/WEB-INF/classes/mathapp.properties \
  && sed -Ei "s/host=.*/host=mathproxy/" $CATALINA_HOME/webapps/MathClient/WEB-INF/classes/mathapp.properties

COPY tomcat-users.xml $CATALINA_HOME/conf

# configure CA APM java agent
COPY setenv.sh $CATALINA_HOME/bin/setenv.sh

EXPOSE 8088
