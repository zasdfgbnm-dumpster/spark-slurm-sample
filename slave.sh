#!/usr/bin/env bash
export SPARK_HOME="$1"
shift
module load java
"$SPARK_HOME/sbin/run-slave.sh" $@
wait
