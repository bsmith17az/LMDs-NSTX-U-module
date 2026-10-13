#!/usr/bin/bash
set -eou pipefail

rm -rf constant/polyMesh constant/*/polyMesh dynamicCode 0/cellToRegion processor* constant/cellToRegion postProcessing/ log.*
blockMesh | tee log.blockMesh
splitMeshRegions -cellZonesOnly -overwrite | tee log.splitMeshRegions
rm -r constant/polyMesh
checkMesh -allRegions -writeSets 'vtp' | tee log.checkMesh
