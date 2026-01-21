#let template(nestoc_object) = {
  import "@preview/ilm:1.4.1"
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
  // TODO: write my own template, because show raw cannot override ilm's
  // show raw: set text(font: ("Noto Sans Mono CJK SC"))
  show: ilm.ilm(
    title: nestoc_object.title,
    author: nestoc_object.author,
    nestoc_object.content()
  )
}
