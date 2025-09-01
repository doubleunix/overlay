{ pkgs
, lib
, fetchurl
, buildPythonPackage
, python
, stdenv
, autoPatchelfHook
}:

let

  pythonEnv = python.withPackages (ps: with ps; [
    # python deps needed during wheel build time (not runtime, see the buildPythonPackage part for that)
    # This list can likely be shortened, but each trial takes multiple hours so won't bother for now.
    absl-py
    astunparse
    dill
    flatbuffers
    gast
    google-pasta
    grpcio
    h5py
    numpy
    opt-einsum
    packaging
    protobuf
    setuptools
    six
    tblib
    tensorboard
    tensorflow-estimator-bin
    termcolor
    typing-extensions
    wheel
    wrapt
  ]);

in

  buildPythonPackage {
    pname   = "tensorflow";
    version = "2.20.0";
    format  = "wheel";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/43/fb/8be8547c128613d82a2b006004026d86ed0bd672e913029a98153af4ffab/tensorflow-2.20.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-X6NymwEm91qZiCuJ+31TZRVyHtqAFKY+JZ54C6Cjc3I=";
    };

    nativeBuildInputs = with pkgs; with python.pkgs; [
      which
      pythonEnv
      cython
      perl
      protobuf
      autoPatchelfHook
    ];

    buildInputs = with pkgs; with python.pkgs; [
      jemalloc
      mpi
      glibcLocales
      git

      # libs taken from system through the TF_SYS_LIBS mechanism
      abseil-cpp
      boringssl
      curl
      double-conversion
      flatbuffers
      giflib
      grpc

      # Necessary to fix the "`GLIBCXX_3.4.30' not found" error
      (icu.override { inherit stdenv; })
      jsoncpp
      libjpeg_turbo
      libpng
      (pybind11.overridePythonAttrs (old: {
        inherit stdenv;
      }))

      stdenv.cc.cc 
      snappy
      sqlite
    ];

    propagatedBuildInputs = with pkgs; with python.pkgs; [
      absl-py
      abseil-cpp
      astunparse
      flatbuffers
      gast
      google-pasta
      grpcio
      h5py
      numpy
      opt-einsum
      packaging
      #(pkgs.protobuf.override { inherit protobuf; })
      protobuf
      six
      tensorflow-estimator-bin
      termcolor
      typing-extensions
      wrapt
    ];

    pythonImportsCheck = [ "tensorflow" ];

    meta = with lib; {
      description = "TensorFlow wheel Python 3.13";
      homepage    = "https://www.tensorflow.org";
      license     = licenses.asl20;
      platforms   = platforms.linux;
    };
  }
