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
  buildInputs = [pkgs.typst];
  propagatedBuildInputs = [
    pkgs.typstPackages.ilm
    noto-fonts-cjk-sc-static
    pkgs.noto-fonts-color-emoji
  ];
  outputs = ["out" "pdf"];
  postInstall = ''
    mkdir $pdf
    ${pkgs.typst}/bin/typst compile main.typ $pdf/main.pdf
  '';
})
