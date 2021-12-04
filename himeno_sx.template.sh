#!/bin/sh

#PBS -S /bin/sh
#PBS -q sx
#PBS -b $N_NODE
#PBS -l elapstim_req=0:00:30
#PBS -jo
#PBS -o result_sx.${OUTPUT_SUFFIX}.txt
#PBS -N ${OUTPUT_SUFFIX}

if [ $PBS_O_WORKDIR ]
then
    cd $PBS_O_WORKDIR
fi

mpirun -np $N_PROC -nn $N_NODE ${BIN_SX}
