#!/bin/bash
echo "usage $0 <docker image version>"
[ "$1" = "" ] && exit 1
pushd containerproxy
mvn package install  -DskipTests
popd
pushd shinyproxy
mvn -U clean package install  -DskipTests
popd

cd shinyproxy-docker/ShinyProxy
rm -f *.jar
cp ../../shinyproxy/target/shinyproxy*.jar .


docker build -t studioetrange/shinyproxy:$1 --build-arg JAR_LOCATION=shinyproxy-*.jar .
docker login
docker push studioetrange/shinyproxy:$1