{ lib, fetchurl, buildPythonPackage, python }:

# Pure wheel install; no dependency on pyprev.tensorflow-bin
buildPythonPackage {
  pname   = "tensorflow";
  version = "2.20.0";
  format  = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/43/fb/8be8547c128613d82a2b006004026d86ed0bd672e913029a98153af4ffab/tensorflow-2.20.0-cp313-cp313-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    # TODO: replace with real sha256 once you fetch it
    sha256 = lib.fakeSha256;
  };

  # keep it minimal; add deps later if import complains
  propagatedBuildInputs = [ ];

  pythonImportsCheck = [ "tensorflow" ];

  meta = with lib; {
    description = "TensorFlow wheel (pinned) for CPython 3.13";
    homepage    = "https://www.tensorflow.org/";
    license     = licenses.asl20;
    platforms   = platforms.linux;
  };
}
