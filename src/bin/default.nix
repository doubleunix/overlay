final: prev:

{
  sl2 = prev.callPackage ./sl2.nix { };

  noelf = prev.callPackage ./noelf.nix { };

  weatherspect = prev.callPackage ./weatherspect.nix { };
}
