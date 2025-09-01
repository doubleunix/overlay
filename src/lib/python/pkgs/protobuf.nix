{ lib
, fetchPypi
, buildPythonPackage
, python
}:

buildPythonPackage rec {
  pname = "protobuf";
  version = "6.31.1";
  pyproject = true;
  build-system = with python.pkgs; [ setuptools ];
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2MrEyYLwuVek3HOoDi6iT6sI5nnA3p3rg19KEtaaypo=";
  };
}
