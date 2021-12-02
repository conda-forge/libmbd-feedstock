#!/usr/bin/env bash
set -ex

if [ "${mpi}" != "nompi" ]; then
  MPI=ON
  ELSI_LIBRARIES="$(pkg-config elsi --libs)"
else
  MPI=OFF
  ELSI_LIBRARIES=""
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
   "-DENABLE_ELSI=${MPI}"
   "-DELSI_LIBRARIES=${ELSI_LIBRARIES}"
   "-DLAPACK_LIBRARIES=lapack;blas"
   "-DSCALAPACK_LIBRARIES=scalapack"
   "-GNinja"
   ".."
)

mkdir -p _build
pushd _build
cmake ${CMAKE_ARGS} -LAH "${cmake_options[@]}"

ninja all
ctest --output-on-failure
ninja install

popd
