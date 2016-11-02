#!/bin/sh

SCRIPT_NAME=$0
echo "+++++++++++++++++++++++++++++++++"
echo "+ SCRIPT_NAME: $SCRIPT_NAME +"
echo "+++++++++++++++++++++++++++++++++"
echo

CURRENT_PATH=`pwd`
echo "CURRENT_PATH=$CURRENT_PATH"
echo

source $CURRENT_PATH/setGrinderEnv.sh

echo "JAVA_HOME=$JAVA_HOME"
echo

echo "CLASSPATH=$CLASSPATH"
echo

echo "---------------------------------"
#tar zxf "${CURRENT_PATH%/*}/jdk-7u79-linux-x64.tar.gz" -C "${CURRENT_PATH%/*}" && mv "${CURRENT_PATH%/*}/jdk1.7.0_79" "${CURRENT_PATH%/*}/jdk1.7.0_79_linux"
"$JAVA_HOME/bin/java" -cp "$CLASSPATH" net.grinder.Console

