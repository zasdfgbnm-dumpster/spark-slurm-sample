#!/usr/bin/env bash
export SPARK_HOME=$1
shift
module load java
"$SPARK_HOME/sbin/start-slave.sh" $@
wait
