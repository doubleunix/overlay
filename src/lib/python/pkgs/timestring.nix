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
  pyproject = false;

  src = fetchFromGitHub {
    owner = "codecov";
    repo = "timestring";
    rev = "d37ceacc5954dff3b5bd2f887936a98a668dda42";
    hash = "sha256-dfV3xdS2CH/uUdJzhq8OxBY6UWIyyxYdSH5OTH5cILo=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    pytz
  ];
}
