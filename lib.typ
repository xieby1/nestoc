#import "@preview/ilm:1.4.1"
#let mytemplate(body) = {
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
  show: ilm.ilm(body)
}
