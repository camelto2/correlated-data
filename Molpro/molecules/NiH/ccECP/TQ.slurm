#!/bin/bash -l
#SBATCH -J TMs
#SBATCH -q shared
#SBATCH -n 4
#SBATCH -C haswell
#SBATCH -t 05:59:00
#!SBATCH -o slurm.o%j
#SBATCH -o job.out

module load molpro
module load python

#Edison there are 24 cores per node
#Cori there are 32 cores per node

#molpro -s -n 4 tz.com
molpro -s -n 4 qz.com
#molpro -s -n 4 5z.com


