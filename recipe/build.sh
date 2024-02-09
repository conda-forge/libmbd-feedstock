#!/usr/bin/env bash
set -ex

if [ "${mpi}" != "nompi" ]; then
  MPI=ON
  if [ "${target_platform}" != "osx-arm64" ]; then
    ELSI=ON
  else
    ELSI=OFF
  fi
else
  MPI=OFF
  ELSI=OFF
fi

if [ "${mpi}" == "openmpi" ]; then
  export OMPI_MCA_plm=isolated
  export OMPI_MCA_btl_vader_single_copy_mechanism=none
  export OMPI_MCA_rmaps_base_oversubscribe=yes
fi

cmake_options=(
   "-DCMAKE_INSTALL_PREFIX=${PREFIX}"
   "-DCMAKE_INSTALL_LIBDIR=lib"
   "-DENABLE_SCALAPACK_MPI=${MPI}"
   "-DENABLE_ELSI=${ELSI}"
   "-DCMAKE_IGNORE_PATH=${PREFIX}/lib/cmake/elsi"
   "-GNinja"
   ".."
)

mkdir -p _build
pushd _build
cmake ${CMAKE_ARGS} -LAH "${cmake_options[@]}"

ninja all
ninja install

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  exit 0
fi

ctest --output-on-failure

popd
