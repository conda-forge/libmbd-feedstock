#!/usr/bin/env bash
set -ex

if [ "${mpi}" != "nompi" ]; then
  MPI=ON
else
  MPI=OFF
fi

cmake_options=(
   "-DCMAKE_INSTALL_PREFIX=${PREFIX}"
   "-DCMAKE_INSTALL_LIBDIR=lib"
   "-DENABLE_SCALAPACK_MPI=${MPI}"
   "-DLAPACK_LIBRARIES=lapack;blas"
   "-DSCALAPACK_LIBRARIES=scalapack"
   "-DMPI_CXX_SKIP_MPICXX=true"
   "-GNinja"
   ".."
)

mkdir -p _build
pushd _build
cmake ${CMAKE_ARGS} -LAH "${cmake_options[@]}"

ninja all install

popd
