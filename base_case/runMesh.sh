set -eou pipefail
rm -rf constant/polyMesh constant/*/polyMesh dynamicCode 0/cellToRegion processor* constant/cellToRegion
blockMesh -dict system/blockMeshDict 2>&1 | tee log.blockMesh
decomposePar 2>&1 | tee log.decomposePar
mpirun -np 4 snappyHexMesh -parallel -overwrite 2>&1 | tee log.snappyHexMesh
reconstructParMesh -constant 2>&1 | tee log.reconstructParMesh
reconstructPar -constant 2>&1 | tee log.reconstructPar
rm -rf processor*
splitMeshRegions -cellZones -overwrite 2>&1 | tee log.splitMeshRegions