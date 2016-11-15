#!/bin/bash
path=$(pwd)

mathapp=/apps/mathapp/apache-tomcat-8.0.33

# instead of copying the files locally you can get MathApp from https://github.com/hrahmed/mathapp-java 

cp $mathapp/MathClient/webapps/MathClient.war .
cp $mathapp/MathProxy/webapps/MathProxy.war .
cp $mathapp/MathSimpleBackend/webapps/MathSimpleBackend.war .
cp $mathapp/MathComplexBackend/webapps/MathComplexBackend.war .
cp $mathapp/../Agent-99.99.tgz IntroscopeAgent.tgz

echo "Building MathClient image"
docker build -f MathClient.Dockerfile -t mathapp_client .

echo "Building MathProxy image"
docker build -f MathProxy.Dockerfile -t mathapp_proxy .

echo "Building MathSimpleBackend image"
docker build -f MathSimpleBackend.Dockerfile -t mathapp_simple_backend .

echo "Building MathComplexBackend image"
docker build -f MathComplexBackend.Dockerfile -t mathapp_complex_backend .
