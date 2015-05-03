#!/bin/sh
### ======================================================================
##
##  Serviio WebUI start Script.
##
### ======================================================================
DIRNAME=`dirname $0`
PROGNAME=`basename $0`

# OS specific support (must be 'true' or 'false').
cygwin=false; darwin=false; linux=false;
case "`uname`" in
    CYGWIN*) cygwin=true ;;
    Darwin*) darwin=true ;;
    Linux)   linux=true ;;
esac

# For Cygwin, ensure paths are in UNIX format before anything is touched
if $cygwin ; then
    [ -n "$SERVIIO_HOME" ] &&
        SERVIIO_HOME=`cygpath --unix "$SERVIIO_HOME"`
    [ -n "$JAVA_HOME" ] &&
        JAVA_HOME=`cygpath --unix "$JAVA_HOME"`
fi

# Setup SERVIIO_HOME
if [ "x$SERVIIO_HOME" = "x" ]; then
    # get the full path (without any relative bits)
    SERVIIO_HOME=`cd $DIRNAME/..; pwd`
fi
export SERVIIO_HOME

# Setup the JVM
if [ "x$JAVA" = "x" ]; then
    if [ "x$JAVA_HOME" != "x" ]; then
     JAVA="$JAVA_HOME/bin/java"
    else
     JAVA="java"
    fi
fi

# Setup the classpath
WEBUI_CLASSPATH="$SERVIIO_HOME/config"
LIB=${SERVIIO_HOME}/plugins
for jar in `ls -1 ${LIB}/*.jar`; do WEBUI_CLASSPATH="${WEBUI_CLASSPATH}:${jar}"; done
LIB=${SERVIIO_HOME}/lib
for jar in `ls -1 ${LIB}/*.jar`; do WEBUI_CLASSPATH="${WEBUI_CLASSPATH}:${jar}"; done

# For Cygwin, switch paths to Windows format before running java
if $cygwin; then
    SERVIIO_HOME=`cygpath --path --windows "$SERVIIO_HOME"`
    JAVA_HOME=`cygpath --path --windows "$JAVA_HOME"`
    WEBUI_CLASSPATH=`cygpath --path --windows "$WEBUI_CLASSPATH"`
fi

# Execute the JVM in the foreground
JAVA_OPTS="-Dserviio.home=$SERVIIO_HOME -Djava.net.preferIPv4Stack=true -Djava.awt.headless=true -Dserviio.remoteHost=serviio"
JVM_OPTS="-Xms5M -XX:+UseParNewGC -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10"
"$JAVA" $JVM_OPTS $JAVA_OPTS -classpath "$WEBUI_CLASSPATH" org.serviio.restui.RestletProxy "$@"
