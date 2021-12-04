include ./autogen/Makefile.in

default: ${BIN_SX} ${BIN_LX}

${BIN_SX}: ${SOURCE}
	mpinfort $< -o $@
	rm *.o

${BIN_LX}: ${SOURCE}
	mpiifort $< -o $@

lx: ${BIN_LX} ${JOB_LX}
	qsub ${JOB_LX}

sx: ${BIN_SX} ${JOB_SX}
	qsub ${JOB_SX}

clean:
	rm -rf autogen *~ *.mod

distclean: clean
	rm -rf params.sh
