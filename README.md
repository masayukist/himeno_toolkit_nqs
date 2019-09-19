# Himeno Benchmark for LX and SX on NQS

The original benchmark is provided by RIKEN RCCS under LGPL ver 2.0 or later.

## Usage

1. Copy `params.sh.sample` to `params.sh`
2. Edit `params.sh` for the parameters of the benchmarks and the systems.
3. Execute `./configure.sh`.
4. Submit a job to the SX system by `make sx` command.
4. Or submit a job to the LX system by `make lx` command.
5. Check the result
    - Check the status of the submitted job using `reqstat` command.
        - If the above command displays nothing, it means that the job finishes.
    - After the job finishes, you can see a generated file, which is `result_*.txt`.
    - Open the result file.
        - The file contains the performance in MFLOPS.
