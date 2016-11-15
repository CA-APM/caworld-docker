#!/bin/sh

EM_HOME=/opt/CA/Introscope10.5.0.16

# copy docker agent files to EM
echo "Copying Docker Agent files to Enterprise Manager"
cp CAAPMDockerMonitor/em/config/modules/DockerMonitorMM.jar $EM_HOME/deploy/DockerMonitorMM.jar
cp CAAPMDockerMonitor/em/ext/xmltv/docker.typeviewers.xml $EM_HOME/ext/xmltv/docker.typeviewers.xml

# enable REST API and create ssl key
echo "Enabling REST API"

keytool -genkey -keyalg RSA -alias jettyssl \
  -keystore ${EM_HOME}/config/internal/server/keystore \
  -storepass password -keypass password -validity 7300 -dname "CN=APMLINUX"

keytool -export -alias jettyssl \
  -keystore ${EM_HOME}/config/internal/server/keystore \
  -storepass password -file ${EM_HOME}/config/internal/server/jettyssl.crt

cp CAAPMDockerMonitor/em/em-jetty-config.xml $EM_HOME/config/em-jetty-config.xml

  sed -i 's/introscope.public.restapi.enabled=false/introscope.public.restapi.enabled=true/' ${EM_HOME}/config/IntroscopeEnterpriseManager.properties
  sed -i 's/log4j.logger.Manager.AppMap.PublicApi=INFO,console,logfile/log4j.logger.Manager.AppMap.PublicApi=INFO,logfile/' ${EM_HOME}/config/IntroscopeEnterpriseManager.properties
  sed -i 's/#introscope.enterprisemanager.webserver.jetty.configurationFile=em-jetty-config.xml/introscope.enterprisemanager.webserver.jetty.configurationFile=em-jetty-config.xml/' ${EM_HOME}/config/IntroscopeEnterpriseManager.properties
  keytool -importcert -noprompt -keystore keystore -alias jettyssl -file ${EM_HOME}/config/internal/server/jettyssl.crt -storepass password

# fix hostname resolution
sed -Ei 's/hosts:      files dns myhostname/hosts:      myhostname files dns/' /etc/nsswitch.conf

# start EM and WebView
echo "Starting Enterprise Manager and WebView"
service em start
service webview start
