#let template(nestoc_object) = {
  import "@preview/ilm:1.4.1"
  // These show rules are applied to content before ilm's show rules being applied
  show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
  let content = {
    // These show rules are applied to content after ilm's show rules being applied
    show raw: set text(font: ("Noto Sans Mono CJK SC"))
    nestoc_object.content()
  }
  ilm.ilm(
    title: nestoc_object.title,
    author: nestoc_object.author,
    content
  )
}
