{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, python
, ... }:

buildPythonPackage rec {
  pname = "timestring";
  version = "1.6.4";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7d1a2060a5f2e34d0c93b1042690074afcea66638fa2cf4dcad2d1bec4deacc";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ];

  # Optional metadata
  meta = with lib; {
    description = "Converts human-expressed time strings to Date/Range objects";
    homepage = "https://pypi.org/project/timestring/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}

