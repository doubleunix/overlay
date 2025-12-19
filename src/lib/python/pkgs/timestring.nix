{
  lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytz
, ...
} @ inputs:

buildPythonPackage rec {
  pname = "timestring";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "codecov";
    repo = "timestring";
    tag = version;
    hash = "";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    pytz
  ];
}
