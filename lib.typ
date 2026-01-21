// TODO: add secret levels
// TODO: API check
#let nestoc(nestoc_fn, heading_offset: 0) = {
  let nestoc_obj = nestoc_fn(heading_offset: heading_offset)
  if heading_offset == 0 {
    import "@preview/ilm:1.4.2"
    // These show rules are applied to content before ilm's show rules being applied
    show: set text(font: ("Noto Serif CJK SC", "Noto Color Emoji"))
    show raw: set text(font: ("Noto Sans Mono CJK SC"))
    ilm.ilm(
      title: nestoc_obj.title,
      author: nestoc_obj.author,
      abstract: nestoc_obj.at("abstract", default: none),
      raw-text: (use-typst-defaults: true),
      nestoc_obj.content
    )
  } else {
    // Naturally, it is better to write heading()nestoc_obj.title, depth:0)
    // But depth only support positive integer.
    heading(nestoc_obj.title, level: heading_offset)
    nestoc_obj.at("abstract", default: none)
    set heading(offset: heading_offset)
    nestoc_obj.content
  }
}
