set -eou pipefail
rm -rf constant/polyMesh constant/*/polyMesh
blockMesh -dict system/blockMeshDict 2>&1 | tee log.blockMesh
snappyHexMesh -overwrite 2>&1 | tee log.snappyHexMesh
splitMeshRegions -cellZones -overwrite 2>&1 | tee log.splitMeshRegions