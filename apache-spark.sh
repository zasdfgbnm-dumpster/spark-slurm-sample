#!/usr/bin/env bash
#SBATCH --job-name=spark-job
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=4gb
#SBATCH --time=100:00:00

# settings
export SPARK_HOME="/ufrc/roitberg/qasdfgtyuiop/spark-dist"
jobscript="$SPARK_HOME/examples/src/main/python/pi.py"
jobargs="20000"
max_slaves=50
min_slaves=4
cores_slave=8
mem_slave=6gb
slave_time=100:00:00

# initialize environment
module load java

# run master
"$SPARK_HOME/sbin/start-master.sh"

# get the link for master
master="spark://$HOSTNAME:7077"

# submit jobs for slaves
slave_jobid=$(
sbatch --array=1-$max_slaves --mem=$mem_slave --nodes=1 --ntasks=$cores_slave --time=$slave_time \
    "$SPARK_HOME/sbin/run-slave.sh" --host "$master" --cores=$cores_slave --memory $mem_slave
)
slave_jobid=$(echo "$slave_jobid"|tr -d 'a-zA-Z ')

# wait until >=$min_slaves number of slaves has started
get_runs() {
    squeue -j $1|awk '{ print $5 }'|grep R|wc -l
}
while [ $(get_runs $slave_jobid) < $min_slaves ]; do sleep 60; done

# run jobscript
"$SPARK_HOME/bin/spark-submit" --master "$master" "$jobscript" "$jobargs"

# kill slaves
scancel $slave_jobid
