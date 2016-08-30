#!/usr/bin/env bash
export SPARK_HOME="/ufrc/roitberg/qasdfgtyuiop/bin/spark"
shift
module load java
"$SPARK_HOME/sbin/run-slave.sh" $@
wait
