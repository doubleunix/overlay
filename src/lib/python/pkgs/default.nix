final: prev:

{

  pythonPackagesExtensions = [

    (pyfinal: pyprev:

      rec {

        callable-module         = pyfinal.callPackage ./callable-module.nix { };
        is-instance             = pyfinal.callPackage ./is-instance.nix { inherit (pyfinal) callable-module; };
        assure                  = pyfinal.callPackage ./assure.nix { };
        mmry                    = pyfinal.callPackage ./mmry.nix { };
        embd                    = pyfinal.callPackage ./embd.nix { inherit (pyfinal) is-instance assure mmry; };
        kern                    = pyfinal.callPackage ./kern.nix { inherit (pyfinal) assure mmry; };
        wnix                    = pyfinal.callPackage ./wnix.nix { inherit (pyfinal) is-instance assure mmry embd kern; };
        webfs                   = pyfinal.callPackage ./webfs.nix { inherit (pyfinal) mmry; };
        python-bin              = pyfinal.callPackage ./python-bin.nix { };

        dvc-s3                  = pyfinal.callPackage ./dvc-s3.nix { };
        lightgbm                = pyfinal.callPackage ./lightgbm.nix { };
        python-cowsay           = pyfinal.callPackage ./python-cowsay.nix { };
        tflite-runtime          = pyfinal.callPackage ./tflite-runtime.nix { };
        lambda-multiprocessing  = pyfinal.callPackage ./lambda-multiprocessing.nix { };
      }

    )

  ];

}
