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
    rev = "acca28885cb6fc781bbfba5acd14e48ecb84ab43";
    hash = "sha256-8ITcyjd8x5VZoukv04dr1YU+bm/+58ff1FlWXfQNLzY=";
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
  shellHook = ''
    export TYPST_ROOT=$(realpath .)
  '';
  preInstall = finalAttrs.shellHook;
  postInstall = ''
    mkdir $pdf
    ${pkgs.typst}/bin/typst compile main.typ $pdf/main.pdf
  '';
})
