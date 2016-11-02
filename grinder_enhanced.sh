#!/bin/sh
# -------------------------------------------------------------------------------
# Filename:		runTest.sh
# Description:	Enhancing The Grinder
# Version:		v0.9
# History:		1. Created 2016/10/27
# Author:		hzcaojianglong
# Email:		caojl01@gmail.com
# Notes:		Use on Linux
# -------------------------------------------------------------------------------

SCRIPT_NAME="$0"
echo "+++++++++++++++++++++++++++++++++"
echo "+ SCRIPT_NAME: $SCRIPT_NAME +"
echo "+++++++++++++++++++++++++++++++++"
echo

# enhanced-grinder的主目录，该变量后续多有使用
ENHANCED_GRINDER_HOME="`pwd`"

# 加载配置文件，如有则使用，如无则根据实际情况进行智能处理。
CONFIG_FILE="conf/enhanced_grinder.conf"
if [ -f $CONFIG_FILE ]; then
    source $CONFIG_FILE
else
    echo "$CONFIG_FILE does not exist!"
    echo
fi

# 判断JAVA_HOME是否正确设置：
#     如有设置且设置正确，则使用该设置；如没有设置或者设置错误，则判断是否有默认java可以使用：
#         如有则使用，如无则中断退出。
if [ -z "$JAVA_HOME" ]; then
    echo "The property JAVA_HOME is not set!"
    TEST_JAVA=`command -v java`
    if [ ! -z "$TEST_JAVA" ]; then
        JAVA_PATH=$TEST_JAVA
        echo "Use system default setting."
    else
        echo "No Java is available!"
        exit 1
    fi
else
    JAVA_PATH="$JAVA_HOME/bin/java"
    if [ "${JAVA_PATH:0:1}" != "/" ]; then
        JAVA_PATH="$ENHANCED_GRINDER_HOME/$JAVA_PATH"
    fi
    if [ ! -f $JAVA_PATH ]; then
        echo "The property JAVA_HOME is incorrectly set!"
        TEST_JAVA=`command -v java`
        if [ ! -z "$TEST_JAVA" ]; then
            JAVA_PATH=$TEST_JAVA
            echo "Use system default setting."
        else
            echo "No Java is available!"
            exit 1
        fi
    fi
fi
echo "JAVA_PATH=$JAVA_PATH" 
echo

# 判断GRINDER_HOME是否正确设置：
#     如有设置且设置正确，则使用该设置；如没有设置或者设置错误，则判断是否有默认Grinder可以使用：
#         如有则使用，如无则中断退出。
if [ -z "$GRINDER_HOME" ]; then
    echo "The property GRINDER_HOME is not set!"
    GRINDER_HOME="$ENHANCED_GRINDER_HOME/grinder-3.11"
    if [ -d $GRINDER_HOME ]; then
        echo "Use system default setting."
    else
        echo "No Grinder is available!"
        exit 2
    fi
else
    if [ "${GRINDER_HOME: -1}" == "/" ]; then
        GRINDER_HOME=${GRINDER_HOME%/*}
    fi
    if [ "${GRINDER_HOME:0:1}" != "/" ]; then
        GRINDER_HOME="$ENHANCED_GRINDER_HOME/$GRINDER_HOME"
    fi
    if [ ! -d $GRINDER_HOME ]; then
        echo "The property GRINDER_HOME is incorrectly set!"
        GRINDER_HOME="$ENHANCED_GRINDER_HOME/grinder-3.11"
        if [ -d $GRINDER_HOME ]; then
            echo "Use system default setting."
        else
            echo "No Grinder is available!"
            exit 2
        fi
    fi
fi
echo "GRINDER_HOME=$GRINDER_HOME"
echo

# 判断DEFAULT_GRINDER_PROPERTIES是否正确设置：
#     如有设置且设置正确，则使用该设置；如没有设置或者设置错误，则判断是否有默认DEFAULT_GRINDER_PROPERTIES可以使用：
#         如有则使用，如无则必须手工指定。
if [ -z "$DEFAULT_GRINDER_PROPERTIES" ]; then
    echo "The property DEFAULT_GRINDER_PROPERTIES is not set!"
    DEFAULT_GRINDER_PROPERTIES="$ENHANCED_GRINDER_HOME/grinder.properties"
    if [ -f $DEFAULT_GRINDER_PROPERTIES ]; then
        echo "Use system default setting."
    else
        DEFAULT_GRINDER_PROPERTIES=""
        echo "No Default grinder.properties is available!"
        echo "You must specify one manually!"
    fi
else
    if [ "${DEFAULT_GRINDER_PROPERTIES:0:1}" != "/" ]; then
        DEFAULT_GRINDER_PROPERTIES="$ENHANCED_GRINDER_HOME/grinder.properties"
    fi
    if [ ! -f $DEFAULT_GRINDER_PROPERTIES ]; then
        echo "The property GRINDER_HOME is incorrectly set!"
        DEFAULT_GRINDER_PROPERTIES="$ENHANCED_GRINDER_HOME/grinder.properties"
        if [ -f $DEFAULT_GRINDER_PROPERTIES ]; then
            echo "Use system default setting."
        else
            DEFAULT_GRINDER_PROPERTIES=""
            echo "No Default grinder.properties is available!"
            echo "You must specify one manually!"
        fi
    fi
fi
echo "DEFAULT_GRINDER_PROPERTIES=$DEFAULT_GRINDER_PROPERTIES"
echo

while true
do
    read -p "Enter the absolute path of your grinder.properties:" GRINDER_PROPERTIES_READ
    GRINDER_PROPERTIES_READ=`echo $GRINDER_PROPERTIES_READ`
    if [ -z "$GRINDER_PROPERTIES_READ" ]; then
        echo "Nothing received! The property GRINDER_PROPERTIES_USER is not set!"
        if [ -z "$DEFAULT_GRINDER_PROPERTIES" ]; then
            echo "No Default grinder.properties is available!"
            echo "You must specify one manually!"
        else
            GRINDER_PROPERTIES_USER=$DEFAULT_GRINDER_PROPERTIES
            echo "Use system default setting."
            break
        fi
    else
        if [ ! "${GRINDER_PROPERTIES_READ:0:1}" == "/" ]; then
            GRINDER_PROPERTIES_READ="$ENHANCED_GRINDER_HOME/$GRINDER_PROPERTIES_READ"
        fi
        if [ "${GRINDER_PROPERTIES_READ: -1}" == "/" ]; then
            GRINDER_PROPERTIES_READ=${GRINDER_PROPERTIES_READ%/*}
        fi
        if [ ! "${GRINDER_PROPERTIES_READ: -18}" == "grinder.properties" ]; then
            GRINDER_PROPERTIES_READ="$GRINDER_PROPERTIES_READ/grinder.properties"
        fi
        if [ -f $GRINDER_PROPERTIES_READ ]; then
            GRINDER_PROPERTIES_USER=$GRINDER_PROPERTIES_READ
            break
        else
            echo "The path [$GRINDER_PROPERTIES_READ] does not exist! Please re-enter."
            echo
        fi
    fi
done
echo "GRINDER_PROPERTIES_USER=$GRINDER_PROPERTIES_USER"
echo

script=`grep '^grinder\.script' $GRINDER_PROPERTIES_USER`
echo $script
processes=`grep '^grinder\.processes' $GRINDER_PROPERTIES_USER`
echo $processes
threads=`grep '^grinder\.thread' $GRINDER_PROPERTIES_USER`
echo $threads
runs=`grep '^grinder\.runs' $GRINDER_PROPERTIES_USER`
echo $runs
duration=`grep '^grinder\.duration' $GRINDER_PROPERTIES_USER`
echo $duration"(ms)"
echo

CLASSPATH="$GRINDER_HOME/lib/*:$ENHANCED_GRINDER_HOME/lib/*"

SCRIPT_PATH_PREFIX=${GRINDER_PROPERTIES_USER%/*}
SCRIPT_PATH_SUFFIX=`echo ${script#*=}`
SCRIPT_PATH="$SCRIPT_PATH_PREFIX/$SCRIPT_PATH_SUFFIX"
echo "SCRIPT_PATH=$SCRIPT_PATH"
echo ---------------------------------
cd `dirname $SCRIPT_PATH` && "$JAVA_PATH" -cp "$CLASSPATH" net.grinder.Grinder "$GRINDER_PROPERTIES_USER"

