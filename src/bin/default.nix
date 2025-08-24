final: prev:

{
  sl2 = prev.callPackage ./sl2.nix { };

  weatherspect = prev.callPackage ./weatherspect.nix { };
}
