let
  sources = import ./nix/sources.nix;
in {
  pkgs ? import sources.nixpkgs {},
  buildLocalTypstEnv ? pkgs.callPackage sources.local-typst-env {},
}: let
  noto-fonts-cjk-sc-static = pkgs.callPackage ./noto-fonts-cjk-sc-static.nix {};
in buildLocalTypstEnv (finalAttrs: {
  src = pkgs.lib.sourceByRegex ./. [".*\.typ$" "^typst.toml$"];

  nativeBuildInputs = [
    # for tests
    pkgs.poppler-utils
    pkgs.python3
    # for deps management
    pkgs.niv
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
