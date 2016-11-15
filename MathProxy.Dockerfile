FROM tomcat:8-jre8

MAINTAINER guenter.grossberger@ca.com

ENV WILY_HOME=$CATALINA_HOME/wily
ENV AGENT_TAR=IntroscopeAgent.tgz
ENV EM_HOST=em
ENV EM_PORT=5001
ENV AGENT_NAME=MathProxy
ENV HEAP=2048m

# install agent
ADD $AGENT_TAR $CATALINA_HOME

# install mathapp application
COPY MathProxy.war $CATALINA_HOME/webapps/
RUN cd webapps \
  && unzip -d MathProxy MathProxy.war \
  && sed -Ei "s/simpleport=.*/simpleport=8080/" $CATALINA_HOME/webapps/MathProxy/WEB-INF/classes/mathapp.properties \
  && sed -Ei "s/simplehost=.*/simplehost=mathsimplebackend/" $CATALINA_HOME/webapps/MathProxy/WEB-INF/classes/mathapp.properties \
  && sed -Ei "s/complexport=.*/complexport=8080/" $CATALINA_HOME/webapps/MathProxy/WEB-INF/classes/mathapp.properties \
  && sed -Ei "s/complexhost=.*/complexhost=mathsimplebackend/" $CATALINA_HOME/webapps/MathProxy/WEB-INF/classes/mathapp.properties \
  && rm MathProxy.war

# configure CA APM java agent
COPY setenv.sh $CATALINA_HOME/bin/setenv.sh
