rm -rf constant/polyMesh
blockMesh 2>&1 | tee log.blockMesh
snappyHexMesh -overwrite 2>&1 | tee log.snappyHexMesh