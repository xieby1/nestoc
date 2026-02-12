{
  npins ? import ../../npins,
  pkgs ? import npins.nixpkgs {},
  buildLocalTypstEnv ? pkgs.callPackage npins.local-typst-env {},
}: let
in buildLocalTypstEnv {
  src = pkgs.fetchFromGitea {
    domain = "codeberg.org";
    owner = "ensko";
    repo = "typst-alexandria";
    rev = "274c7bbad48e0c34a620495ef4e1645cc354837d";
    hash = "sha256-fvV4DGIkDRADtM2IG8wcaVF5cjmhayCe9qCUtJ+w638=";
  };
  patches = [ ./add-bib.patch ];
}
