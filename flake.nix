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

    default = with pkgs; buildEnv {

      name = "overlay";
      ignoreCollisions = true;

      paths = [

        (python314.withPackages (ps: with ps; [
          numpy
          pandas
          python-bin
        ]))

        (python315.withPackages (ps: with ps; [
          numpy
          pandas
          python-bin
        ]))

        (python314FreeThreading.withPackages (ps: with ps; [
          numpy
          python-bin
        ]))

        (python315FreeThreading.withPackages (ps: with ps; [
          numpy
          python-bin
        ]))

      ];
    };

  in

  {

    packages.${system} = (import ./src {} pkgs) // { inherit default; };

    overlays.default = overlay;

  };
}
