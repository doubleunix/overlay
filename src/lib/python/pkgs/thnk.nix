{
  lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytest
, jax
, nltk
, timestring
, is-instance
, ...
} @ inputs:

buildPythonPackage rec {
  pname = "thnk";
  version = "0.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notarealdeveloper";
    repo = "think";
    tag = version;
    hash = "";
  };

  build-system = [ setuptools ];

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    jax
    nltk
    timestring
    is-instance
  ];
}
