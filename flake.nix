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

    all = (ps: with ps; [
      # packaging
      pip
      build
      pytest
      setuptools
      cython

      # basics
      ipython
      sly
      curio

      # net
      requests
      beautifulsoup4

      # numerical
      numpy
      editdistance

      # ours
      assure
      is-instance
      python-bin
      mmry
      webfs

    ]);

    std = (ps: with ps; [
      # packaging
      twine

      # net
      yt-dlp

      # numerical
      scipy
      pandas
      matplotlib
      seaborn
      scikit-learn
      lambda-multiprocessing
      lightgbm

      # for sklearn
      lz4
    ]);

    pythons = with pkgs; {
      py313  = python313.withPackages (ps: all ps ++ std ps);
      py314  = python314.withPackages (ps: all ps ++ std ps);
      py315  = python315.withPackages (ps: all ps ++ std ps);
      py313t = python313FreeThreading.withPackages (ps: all ps);
      py314t = python314FreeThreading.withPackages (ps: all ps);
      py315t = python315FreeThreading.withPackages (ps: all ps);
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

    check-python-std = pyenv: ''
      set -euo pipefail
      export PATH=$PATH:${pkgs.cowsay}/bin
      ${pyenv}/bin/python << 'EOF' | tee $out
      import sys
      import bin
      import numpy
      import pandas
      import sklearn
      import lightgbm
      print(f"python version is: {sys.version}")
      print(f"numpy version is: {numpy.__version__}")
      print(f"pandas version is: {pandas.__version__}")
      print(f"sklearn version is: {sklearn.__version__}")
      print(f"lightgbm version is: {lightgbm.__version__}")
      print(bin.cowsay("Its working!"))
      EOF
    '';

    check-python-all = pyenv: ''
      set -euo pipefail
      export PATH=$PATH:${pkgs.cowsay}/bin
      ${pyenv}/bin/python << 'EOF' | tee $out
      import sys
      import bin
      import numpy
      import is_instance
      print(f"python version is: {sys.version}")
      print(f"numpy version is: {numpy.__version__}")
      print(bin.cowsay("Its working!"))
      EOF
    '';

  in
  {
    packages.${system} = packages;

    checks.${system} = with pythons; {
      py313'  = pkgs.runCommand "py313"  { } (check-python-std py313);
      py314'  = pkgs.runCommand "py314"  { } (check-python-std py314);
      py315'  = pkgs.runCommand "py315"  { } (check-python-std py315);

      py313  = pkgs.runCommand "py313"  { } (check-python-all py313);
      py314  = pkgs.runCommand "py314"  { } (check-python-all py314);
      py315  = pkgs.runCommand "py315"  { } (check-python-all py315);
      py313t = pkgs.runCommand "py313t" { } (check-python-all py313t);
      py314t = pkgs.runCommand "py314t" { } (check-python-all py314t);
      py315t = pkgs.runCommand "py315t" { } (check-python-all py315t);
    };

    overlays.default = overlay;
  };
}

