{
  description = "Packages not yet in Nixpkgs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:

  let

    system = "x86_64-linux";

    overlay = (import ./src);

    pkgs = import nixpkgs {
      inherit system;
      overlays = [ overlay ];
      config.allowUnfree = true;
    };

    lib = pkgs.lib;

    common   = (ps: with ps; [ ipython numpy is-instance python-bin ]);
    standard = (ps: with ps; [ pandas scikit-learn lightgbm lambda-multiprocessing ]);

    pythons = with pkgs; {
      py314  = python314.withPackages (ps: common ps ++ standard ps);
      py315  = python315.withPackages (ps: common ps ++ standard ps);
      py313t = python313FreeThreading.withPackages (ps: common ps);
      py314t = python314FreeThreading.withPackages (ps: common ps);
      py315t = python315FreeThreading.withPackages (ps: common ps);
    };

    default = with pkgs; buildEnv {
      name = "overlay";
      ignoreCollisions = true;
      paths = builtins.attrValues pythons;
    };

    overlayNames = builtins.attrNames (import ./src {} pkgs);
    attrset      = pkgs.__splicedPackages;
    derivations  = lib.filterAttrs (k: v: lib.elem k overlayNames && lib.isDerivation v) attrset;
    packages     = derivations // pythons // { inherit default; overlay = default; };

    check-python = pyenv: ''
      set -euo pipefail
      ${pyenv}/bin/python<< 'EOF' | tee $out
      import sys
      import numpy
      import pandas
      import sklearn
      import lightgbm
      print(f"python version is: {sys.version}")
      print(f"numpy version is: {numpy.__version__}")
      print(f"pandas version is: {pandas.__version__}")
      print(f"sklearn version is: {sklearn.__version__}")
      print(f"lightgbm version is: {lightgbm.__version__}")
      EOF
    '';

  in
  {
    packages.${system} = packages;

    checks.${system} = {
      py315 = pkgs.runCommand "py315" { } (check-python packages.py315);
    };

    overlays.default = overlay;
  };
}

