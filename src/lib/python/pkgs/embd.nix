{
  lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, pytest
, pandas
, sentence-transformers
, is-instance
, assure
, mmry
, ...
} @ inputs:

buildPythonPackage rec {
  pname = "embd";
  version = "latest";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "notarealdeveloper";
    repo = "embd";
    rev = "0a691990db7476db648d8bad07a41b57d7deb79f";
    hash = "sha256-KCvt3DrqsjEl8cSra1x+ukr5F4oRMWOU2QOJLbRKkCk=";
  };

  build-system = [ setuptools ];

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    pandas
    sentence-transformers
    is-instance
    assure
    mmry
  ];
}
