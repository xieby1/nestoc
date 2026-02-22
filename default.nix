let
  npins = import ./npins;
in {
  pkgs ? import npins.nixpkgs {},
  buildLocalTypstEnv ? pkgs.callPackage npins.local-typst-env {},
}: let
  inherit (import npins.gitignore-nix { inherit (pkgs) lib; }) gitignoreSource;
in buildLocalTypstEnv (finalAttrs: {
  src = gitignoreSource ./.;

  nativeBuildInputs = [
    # for tests
    pkgs.poppler-utils
    pkgs.python3
    # for deps management
    pkgs.npins
  ];

  buildInputs = [
    pkgs.typst
    pkgs.typstPackages.fletcher
  ];
  propagatedBuildInputs =
  # propagatedBuildInputs for nestoc
  [ ]
  # propagatedBuildInputs for nestemp
  ++ [
    # Typst packages
    pkgs.typstPackages.glossy

    # Fonts
    (pkgs.callPackage ./nestemp/noto-fonts-cjk-sc-static.nix {})
    pkgs.noto-fonts-color-emoji
  ];
})
