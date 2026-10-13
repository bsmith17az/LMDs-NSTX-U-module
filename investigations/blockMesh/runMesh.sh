#!/usr/bin/bash
set -eou pipefail
cd "${0%/*}" || exit 1
rm -rf log.* postProcessing/ constant/polyMesh/ constant/{lm_cps,module,holder}/polyMesh/
blockMesh | tee log.blockMesh
splitMeshRegions -cellZonesOnly -overwrite | tee log.splitMeshRegions
rm -r constant/polyMesh
checkMesh -allRegions -writeSets 'vtp' | tee log.checkMesh
