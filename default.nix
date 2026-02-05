let
  npins = import ./npins;
in {
  pkgs ? import npins.nixpkgs {},
  buildLocalTypstEnv ? pkgs.callPackage npins.local-typst-env {},
}: let
  noto-fonts-cjk-sc-static = pkgs.callPackage ./noto-fonts-cjk-sc-static.nix {};
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
  propagatedBuildInputs = [
    (pkgs.typstPackages.ilm.overrideAttrs (finalAttrs: prevAttrs: {
      version = "1.4.2";
      src = pkgs.fetchzip {
        hash = "sha256-aELsI13NxkUbjqBR363Wwzd0eJ8UzP1mLsQ28+z8qbg=";
        url = "https://packages.typst.org/preview/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
        stripRoot = false;
      };
      prePatch = ''
        sed -i '/compiler/d' typst.toml
      '';
    }))
    noto-fonts-cjk-sc-static
    pkgs.noto-fonts-color-emoji
  ];
})
