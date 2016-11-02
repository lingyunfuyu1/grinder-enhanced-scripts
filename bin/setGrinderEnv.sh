#!/bin/sh
SCRIPT_NAME=$0
#echo "+++++++++++++++++++++++++++++++++"
#echo "+ SCRIPT_NAME: $SCRIPT_NAME +"
#echo "+++++++++++++++++++++++++++++++++"
#echo

CURRENT_PATH=`pwd`
#echo "CURRENT_PATH=$CURRENT_PATH"
#echo

#GRINDER_PATH="$CURRENT_PATH/../grinder-3.11"
GRINDER_PATH="${CURRENT_PATH%/*}/grinder-3.11"
#echo "GRINDER_PATH=$GRINDER_PATH"
#echo

GRINDER_PROPERTIES="$GRINDER_PATH/examples/grinder.properties"
#echo "GRINDER_PROPERTIES=$GRINDER_PROPERTIES"
#echo

CLASSPATH="$GRINDER_PATH/lib/grinder.jar:$CLASSPATH"
#echo "CLASSPATH=$CLASSPATH"
#echo

JAVA_HOME="${CURRENT_PATH%/*}/jdk1.7.0_79_linux"
#echo "JAVA_HOME=$JAVA_HOME"
#echo
