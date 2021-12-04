#!/bin/sh
#PBS -S /bin/sh
#PBS -q lx
#PBS -b $N_NODE
#PBS -l elapstim_req=0:01:00
#PBS -jo
#PBS -o result_lx.${OUTPUT_SUFFIX}.txt
#PBS -N ${OUTPUT_SUFFIX}

if [ $PBS_O_WORKDIR ]
then
    cd $PBS_O_WORKDIR
fi

mpirun -ppn $N_PROC_PER_NODE -np $N_PROC ${BIN_LX}
