let
  # latest nixpkgs 25.11
  pkgs = import ((import <nixpkgs> {}).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "77ef7a29d276c6d8303aece3444d61118ef71ac2";
    hash = "sha256-XsM7GP3jHlephymxhDE+/TKKO1Q16phz/vQiLBGhpF4=";
  }) {};
  buildLocalTypstEnv = pkgs.callPackage (pkgs.fetchFromGitHub {
    owner = "xieby1";
    repo = "local-typst-env";
    rev = "030f5dc43b868e87acef3360c9d9fe46bdb1e873";
    hash = "sha256-bq7h6RQ4BKJK8TAH9g2C6EtdsS6ao+zN9ra3guxt9fU=";
  }) {};
  noto-fonts-cjk-sc-static = pkgs.callPackage ./noto-fonts-cjk-sc-static.nix {};
in buildLocalTypstEnv (finalAttrs: {
  src = pkgs.lib.sourceByRegex ./. [".*\.typ$" "^typst.toml$"];

  # for tests
  nativeBuildInputs = [
    pkgs.poppler-utils
    pkgs.python3
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
  outputs = ["out" "pdf"];
  postInstall = ''
    mkdir $pdf
    ${pkgs.typst}/bin/typst compile main.typ $pdf/main.pdf
  '';
})
