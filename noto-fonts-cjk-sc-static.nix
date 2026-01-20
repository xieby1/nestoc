{
  runCommand,
  fetchurl,
}: let
  name = "noto-fonts-cjk-sc-static";
  base-url = "https://github.com/notofonts/noto-cjk/raw/f8d157532fbfaeda587e826d4cd5b21a49186f7c";
in runCommand name {} ([''
  mkdir -p $out/share/fonts/${name}
''] ++ (map (font: ''
  ln -s ${font} $out/share/fonts/${name}/${font.name}
'') [
  (fetchurl {
    url = "${base-url}/Sans/Mono/NotoSansMonoCJKsc-Regular.otf";
    sha256 = "1xry2pypppf17wbvkp5bxrhjgv96wbi78h7qppnpr21ldcvwq17c";
  })
  (fetchurl {
    url = "${base-url}/Sans/OTF/SimplifiedChinese/NotoSansCJKsc-Regular.otf";
    sha256 = "0jxpcl1hss5nxvv994ir7rfi7fw5agxq8zharvgzsyf3dx7jaxic";
  })
  (fetchurl {
    url = "${base-url}/Serif/OTF/SimplifiedChinese/NotoSerifCJKsc-Regular.otf";
    sha256 = "1jhjin8yngzjngl6l9f5cawc2cm51zi43301ain5b0yz50kawbia";
  })
  (fetchurl {
    url = "${base-url}/Sans/Mono/NotoSansMonoCJKsc-Bold.otf";
    sha256 = "1p6bblma1982qkw5njgapi7yrlyb6k763f5ph3h477k1q3gzwlm4";
  })
  (fetchurl {
    url = "${base-url}/Sans/OTF/SimplifiedChinese/NotoSansCJKsc-Bold.otf";
    sha256 = "02jckcnp6nch7xa51h646bgm69gi19im120a64yb9yd7j2hx3w5m";
  })
  (fetchurl {
    url = "${base-url}/Serif/OTF/SimplifiedChinese/NotoSerifCJKsc-Bold.otf";
    sha256 = "0wzw70xrq3pym7md5apl4ja1pwcmybm6dq1h5b3vr0ifdi5pvw4a";
  })
]))
