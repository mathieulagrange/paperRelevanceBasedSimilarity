#!/bin/bash

#SBATCH --job-name=Matlab
#SBATCH --nodes=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=128GB
#SBATCH --time=48:00:00

# http://www.mathworks.com/matlabcentral/answers/93696-how-do-i-change-the-matlab-preferences-directory-location
# http://www.mathworks.com/matlabcentral/answers/97141-why-am-i-unable-to-start-a-local-matlabpool-from-multiple-matlab-sessions-that-use-a-shared-preferen

module purge
module load matlab/2016b

cd /share/apps/examples/matlab/parfor-prefdir

if [ "$SLURM_JOBTMP" == "" ]; then
    export SLURM_JOBTMP=/state/partition1/$USER/$$
    mkdir -p $SLURM_JOBTMP
fi
export MATLAB_PREFDIR=$(mktemp -d $SLURM_JOBTMP/matlab-XXXX)

echo
echo "Hostname: $(hostname)"
echo

cat<<EOF | srun matlab -nodisplay

parpool('local', $SLURM_CPUS_PER_TASK)

cd /home/vl1019/taslp16/experiments/deprecated/supervised

addpath(genpath('/home/vl1019/scattering.m'))

supervised_script

exit

EOF

rm -rf $SLURM_JOBTMP/*


