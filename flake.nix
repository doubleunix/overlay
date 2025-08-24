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

    common   = (ps: with ps; [ ipython numpy is-instance python-bin ]);
    standard = (ps: with ps; [ pandas scikit-learn lightgbm lambda-multiprocessing ])

    pythons = {
      py314  = python314.withPackages (ps: with ps; common ++ standard);
      py315  = python315.withPackages (ps: with ps; common ++ standard);
      py313t = python313FreeThreading.withPackages (ps: with ps; common);
      py314t = python314FreeThreading.withPackages (ps: with ps; common);
      py315t = python315FreeThreading.withPackages (ps: with ps; common);
    };

    default = with pkgs; buildEnv {
      name = "overlay";
      ignoreCollisions = true;
      paths = builtins.attrValues pythons;
    };

    packages = (import ./src {} pkgs) // pythons // { inherit default; };

  in

  {

    packages.${system} = packages;

    checks.${system} = {

      py315 = pkgs.runCommand "py315" { } ''
          set -euo pipefail
          ${packages.py315}/bin/python - << 'EOF'
          import sklearn
          import lightgbm
          EOF
          touch $out
        '';
    };

    overlays.default = overlay;
  };
}
