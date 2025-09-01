{ lib
, fetchurl
, buildPythonPackage
, python
, stdenv
, autoPatchelfHook
}:

  buildPythonPackage {
    pname   = "tensorflow";
    version = "2.20.0";
    format  = "wheel";

    src = fetchurl {
      url = "https://files.pythonhosted.org/packages/43/fb/8be8547c128613d82a2b006004026d86ed0bd672e913029a98153af4ffab/tensorflow-2.20.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
      sha256 = "sha256-X6NymwEm91qZiCuJ+31TZRVyHtqAFKY+JZ54C6Cjc3I=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];

    buildInputs = [ stdenv.cc.cc ];

    propagatedBuildInputs = [ ];

    pythonImportsCheck = [ "tensorflow" ];

    meta = with lib; {
      description = "TensorFlow wheel Python 3.13";
      homepage    = "https://www.tensorflow.org";
      license     = licenses.asl20;
      platforms   = platforms.linux;
    };
  }
