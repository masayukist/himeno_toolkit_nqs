#!/bin/sh

if [ ! -e ./params.sh ]
then
	echo "ERROR: generate params.sh before executing this script."
	exit 1
fi

# Configure the parameters
source ./params.sh

### Do not edit the following codes ###

export N_PROC=`expr $IDIV \* $JDIV \* $KDIV`
export N_PROC_PER_NODE=`expr $N_PROC / $N_NODE`

echo himeno Size: $SIZE
echo himeno DDM: $IDIV-$JDIV-$KDIV
echo Nodes: $N_NODE
echo MPI processes: $N_PROC
echo Processes per node: $N_PROC_PER_NODE

export OUTPUT_SUFFIX=nn_${N_NODE}_np_${N_PROC}_${SIZE}_${IDIV}-${JDIV}-${KDIV}

export SOURCE=./autogen/himeno.${OUTPUT_SUFFIX}.f90
export BIN_LX=./autogen/himeno_lx.${OUTPUT_SUFFIX}.bin
export BIN_SX=./autogen/himeno_sx.${OUTPUT_SUFFIX}.bin
export JOB_LX=./autogen/himeno_lx.${OUTPUT_SUFFIX}.sh
export JOB_SX=./autogen/himeno_sx.${OUTPUT_SUFFIX}.sh

mkdir -p ./autogen

envsubst < himenoBMTxpr.template.f90 > ${SOURCE} 

echo ${SOURCE} is set.

cat <<EOF > ./autogen/Makefile.in
INFILE=${INFILE}
SOURCE=${SOURCE}
BIN_LX=${BIN_LX}
BIN_SX=${BIN_SX}
JOB_LX=${JOB_LX}
JOB_SX=${JOB_SX}
EOF

################ script for SX

envsubst '$N_NODE $OUTPUT_SUFFIX $N_PROC $BIN_SX' < himeno_sx.template.sh > ${JOB_SX}
chmod 755 ${JOB_SX}

echo ${JOB_SX} is set.

################ script for LX

envsubst '$N_NODE $OUTPUT_SUFFIX $N_PROC_PER_NODE $N_PROC $BIN_LX' < himeno_lx.template.sh > ${JOB_LX}
chmod 755 ${JOB_LX}

echo ${JOB_LX} is set.
