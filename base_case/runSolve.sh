#!/usr/bin/bash
set -eou pipefail
NPROCS=$(foamDictionary constant/sys_params -entry NPROCS -value)
decomposePar -allRegions -fileHandler collated | tee log.decomposePar
mpirun -np $NPROCS chtMultiRegionFoam -parallel | tee log.solve
reconstructPar -allRegions -fileHandler collated | tee log.reconstructPar
