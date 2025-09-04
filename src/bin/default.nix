final: prev:

{
  sl2 = prev.callPackage ./sl2.nix { };

  noelf = prev.callPackage ./noelf.nix { };

  weatherspect = prev.callPackage ./weatherspect.nix { };

  kdenlive = (prev.kdenlive.overrideAttrs (prev: {
    nativeBuildInputs = (prev.nativeBuildInputs or []) ++ [ prev.makeBinaryWrapper ];
    postInstall = (prev.postInstall or "") + ''
      wrapProgram $out/bin/kdenlive \
        --prefix LADSPA_PATH : ${prev.rnnoise-plugin}/lib/ladspa
    '';
  }));

}
