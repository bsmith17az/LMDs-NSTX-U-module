set -eou pipefail
rm -rf constant/polyMesh constant/*/polyMesh dynamicCode
blockMesh -dict system/blockMeshDict 2>&1 | tee log.blockMesh
decomposePar 
snappyHexMesh -overwrite 2>&1 | tee log.snappyHexMesh
splitMeshRegions -cellZones -overwrite 2>&1 | tee log.splitMeshRegions