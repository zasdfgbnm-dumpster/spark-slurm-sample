#!/bin/sh
#SBATCH --job-name=spark-master
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=2gb
#SBATCH --time=100:00:00
 
hostname > master-host
rm -rf /ufrc/roitberg/qasdfgtyuiop/spark-dist/logs/*
module load java/1.8.0_31
/ufrc/roitberg/qasdfgtyuiop/spark-dist/sbin/run-master.sh
