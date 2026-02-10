{
  npins ? import ../npins,
  pkgs ? import npins.nixpkgs {},
  buildLocalTypstEnv ? pkgs.callPackage npins.local-typst-env {},
}: buildLocalTypstEnv (finalAttrs: {
  src = (import npins.gitignore-nix { inherit (pkgs) lib; }).gitignoreSource ./.;
  propagatedBuildInputs = [
    # Typst packages
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
    pkgs.typstPackages.glossy

    # Fonts
    (pkgs.callPackage ./noto-fonts-cjk-sc-static.nix {})
    pkgs.noto-fonts-color-emoji
  ];
})
