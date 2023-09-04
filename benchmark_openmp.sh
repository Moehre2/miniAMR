#!/usr/bin/env zsh

### Slurm config
#SBATCH --job-name=miniAMR_benchmark_openmp
#SBATCH --account=thes1472
#SBATCH --output=output_%j.txt
#SBATCH --time=01:00:00
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=48
#SBATCH --exclusive

repetitions=2

source setupenv.sh

mkdir -p benchmarks/openmp
rm -rf benchmarks/openmp/*.txt

cd openmp
make clean
make
for i in $(seq $repetitions); do
    OMP_NUM_THREADS=48 mpirun -np 2 ./miniAMR.x --num_refine 4 --max_blocks 4000 --init_x 1 --init_y 1 --init_z 1 --npx 2 --npy 1 --npz 1 --nx 8 --ny 8 --nz 8 --num_objects 2 --object 2 0 -1.10 -1.10 -1.10 0.030 0.030 0.030 1.5 1.5 1.5 0.0 0.0 0.0 --object 2 0 0.5 0.5 1.76 0.0 0.0 -0.025 0.75 0.75 0.75 0.0 0.0 0.0 --num_tsteps 20 --checksum_freq 4 --stages_per_ts 8 > ../benchmarks/openmp/${i}.txt
done
