#!/usr/bin/env bash
#SBATCH --job-name=spark-job
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --mem-per-cpu=4gb
#SBATCH --time=100:00:00
#SBATCH --output=spark-job.out

# settings
export SPARK_HOME="/ufrc/roitberg/qasdfgtyuiop/spark-dist"
jobscript="$SPARK_HOME/examples/src/main/python/pi.py"
jobargs="20000"
max_slaves=50
cores_slave=1
mem_slave=6gb
slave_time=100:00:00

# initialize environment
module load java

# run master
"$SPARK_HOME/sbin/start-master.sh"

# get the link for master
master="spark://$HOSTNAME:7077"
echo "master started"

# submit jobs for slaves
slave_jobid=$(
ssh gator4 sbatch --array=1-$max_slaves --mem=$mem_slave --nodes=1 --ntasks=$cores_slave --time=$slave_time --output="$SLURM_SUBMIT_DIR/slave-%a.out" \
    "$SLURM_SUBMIT_DIR/slave.sh" "$SPARK_HOME" "$master" --cores $cores_slave --memory $mem_slave
)
slave_jobid=$(echo "$slave_jobid"|tr -d 'a-zA-Z ')
echo "slave slurm jobs submited, waiting for slaves to be scheduled..."

# run jobscript
"$SPARK_HOME/bin/spark-submit" --master "$master" "$jobscript" "$jobargs"
echo "job script finish, now kill slaves"

# kill slaves
ssh gator4 scancel $slave_jobid
