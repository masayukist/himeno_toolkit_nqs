#!/bin/sh

if [ ! -e params.sh ]
then
	echo "ERROR: generate params.sh before executing this script."
	exit 1
fi

# Configure the parameters
source params.sh

### Do not edit the following codes ###

N_PROC=`expr $IDIV \* $JDIV \* $KDIV`
N_PROC_PER_NODE=`expr $N_PROC / $N_NODE`

echo himeno Size: $SIZE
echo himeno DDM: $IDIV-$JDIV-$KDIV
echo Nodes: $N_NODE
echo MPI processes: $N_PROC
echo Processes per node: $N_PROC_PER_NODE

OUTPUT_SUFFIX=nn_${N_NODE}_np_${N_PROC}_${SIZE}_${IDIV}-${JDIV}-${KDIV}

INFILE=./autogen/himeno.${OUTPUT_SUFFIX}.in
SOURCE=./autogen/himeno.${OUTPUT_SUFFIX}.f90
BIN_LX=./autogen/himeno_lx.${OUTPUT_SUFFIX}.bin
BIN_SX=./autogen/himeno_sx.${OUTPUT_SUFFIX}.bin
JOB_LX=./autogen/himeno_lx.${OUTPUT_SUFFIX}.sh
JOB_SX=./autogen/himeno_sx.${OUTPUT_SUFFIX}.sh

mkdir -p ./autogen

sed -e s/himeno.in/himeno.${OUTPUT_SUFFIX}.in/ himenoBMTxpr.f90 > ${SOURCE}

cat <<EOF > ${INFILE}
$SIZE
$IDIV
$JDIV
$KDIV
EOF

cat <<EOF > ./autogen/Makefile.in
INFILE=${INFILE}
SOURCE=${SOURCE}
BIN_LX=${BIN_LX}
BIN_SX=${BIN_SX}
JOB_LX=${JOB_LX}
JOB_SX=${JOB_SX}
EOF

echo ${INFILE} is set.

################ script for SX

cat <<EOF > ${JOB_SX}
#!/bin/sh

#PBS -S /bin/sh
#PBS -q sx
#PBS -b $N_NODE
#PBS -l elapstim_req=0:00:30
#PBS -jo
#PBS -o result_sx.${OUTPUT_SUFFIX}.txt
#PBS -N ${OUTPUT_SUFFIX}

if [ \$PBS_O_WORKDIR ]
then
    cd \$PBS_O_WORKDIR
fi

mpirun -np $N_PROC -nn $N_NODE ${BIN_SX}
EOF

chmod 755 ${JOB_SX}

echo ${JOB_SX} is set.

################ script for LX

cat <<EOF > ${JOB_LX}
#!/bin/sh

#PBS -S /bin/sh
#PBS -q lx
#PBS -b $N_NODE
#PBS -l elapstim_req=0:00:30
#PBS -jo
#PBS -o result_lx.${OUTPUT_SUFFIX}.txt
#PBS -N ${OUTPUT_SUFFIX}

if [ \$PBS_O_WORKDIR ]
then
    cd \$PBS_O_WORKDIR
fi

mpirun -ppn $N_PROC_PER_NODE -np $N_PROC ${BIN_LX}
EOF

chmod 755 ${JOB_LX}

echo ${JOB_LX} is set.
