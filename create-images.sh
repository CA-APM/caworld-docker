#!/bin/sh
path=$(pwd)

mathapp=/apps/mathapp/apache-tomcat-8.0.33

echo "Building MathClient image"
cd $path/MathClient
cp $mathapp/MathClient/webapps/MathClient.war .
cp $mathapp/../Agent-99.99.tgz IntroscopeAgent.tgz
./build-image.sh

echo "Building MathProxy image"
cd $path/MathProxy
cp $mathapp/MathProxy/webapps/MathProxy.war .
cp $mathapp/../Agent-99.99.tgz IntroscopeAgent.tgz
./build-image.sh

echo "Building MathSimpleBackend image"
cd $path/MathSimpleBackend
cp $mathapp/MathSimpleBackend/webapps/MathSimpleBackend.war .
cp $mathapp/../Agent-99.99.tgz IntroscopeAgent.tgz
./build-image.sh

echo "Building MathComplexBackend image"
cd $path/MathComplexBackend
cp $mathapp/MathComplexBackend/webapps/MathComplexBackend.war .
cp $mathapp/../Agent-99.99.tgz IntroscopeAgent.tgz
./build-image.sh
