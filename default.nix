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
    # for svg
    pkgs.pdf2svg
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
    (let
      base-url = "https://github.com/notofonts/noto-cjk/raw/f8d157532fbfaeda587e826d4cd5b21a49186f7c";
    in pkgs.runCommand "noto" {} ([''
      mkdir -p $out/share/fonts/noto
    ''] ++ (map (font: ''
      ln -s ${font} $out/share/fonts/noto/${font.name}
    '') [
      (pkgs.fetchurl {
        url = "${base-url}/Serif/OTF/SimplifiedChinese/NotoSerifCJKsc-Regular.otf";
        sha256 = "1jhjin8yngzjngl6l9f5cawc2cm51zi43301ain5b0yz50kawbia";
      })
      (pkgs.fetchurl {
        url = "${base-url}/Serif/OTF/SimplifiedChinese/NotoSerifCJKsc-Bold.otf";
        sha256 = "0wzw70xrq3pym7md5apl4ja1pwcmybm6dq1h5b3vr0ifdi5pvw4a";
      })
    ])))
    pkgs.noto-fonts-color-emoji
    (pkgs.fetchzip {
      url = "https://github.com/SpaceTimee/Fusion-JetBrainsMapleMono/releases/download/1.2304.79/JetBrainsMapleMono-NF-XX-NL-XX.zip";
      hash = "sha256-KXxHCm69TuniZPDLSO2Y0ef/DydXxj2OAciYGB+ZAzw=";
      stripRoot = false;
      postFetch = ''
        mkdir -p $out/share/fonts/JetBrainsMapleMono
        mv $out/*.ttf $out/share/fonts/JetBrainsMapleMono
      '';
    })
  ];
})
