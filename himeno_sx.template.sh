#!/bin/sh
#PBS -S /bin/sh
#PBS -q sx
#PBS -T necmpi
#PBS --venode $N_NODE
#PBS -l elapstim_req=0:01:00
#PBS -jo
#PBS -o result_sx.${OUTPUT_SUFFIX}.txt
#PBS -N ${OUTPUT_SUFFIX}

if [ $PBS_O_WORKDIR ]
then
    cd $PBS_O_WORKDIR
fi

mpirun -np $N_PROC ${BIN_SX}
