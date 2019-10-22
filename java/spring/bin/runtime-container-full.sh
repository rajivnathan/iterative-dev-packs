#!/bin/sh

# set -e -o pipefail

date
echo Started - Full build using runtime container folders

date
echo cd /root/idp/src/ and listing
cd /root/idp/src
ls -la

date
echo running full maven build in /root/idp/src
mvn -Dmaven.repo.local=/root/idp/cache/.m2/repository -f ./pom.xml package -Dmaven.test.skip=true

date
echo listing /root/idp/src/target after mvn
ls -la /root/idp/src/target

TARGET_JAR=$(ls target/*.jar | head -n1)
APP_JAR=/root/app.jar

# Kill the Spring App if its running
date
echo Stopping the Spring App
pkill -f "java -jar $APP_JAR" || echo "No Java Spring Application process found"

# Copy the maven built jar from the PVC
date
echo Copying the maven built jar from the PVC
cp -rf $TARGET_JAR $APP_JAR

# Start the Spring Application
date
echo Starting the Spring Application
java -jar $APP_JAR >> /var/log/app.log 2>&1 &

date
echo Finished - Full build using runtime container folders
