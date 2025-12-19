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
    rev = "5795710750432b5647fd210f55b75433de96d1c5";
    hash = "sha256-PHzxz2lEh280AcDUjm/fMLMLh58ZYpxltWbApW0yP28=";
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
