#import "../../../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "父模块的题目",
author: "xieby1",
chapter-pagebreak: false,
body: [
父模块到总文档的各级标题为直接映射：

#table(
  columns: (auto, auto, auto),
  table.header([`parent/main.typ`], [..], [总文档]),
  [题目], [..], [三级标题],
  [一级标题], [..], [四级标题],
  [..], [..], [..],
)

= 父模块的一级标题

父模块的一级标题下方的的内容

#{
  import "./child/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+1)
}
])
#nestoc(nestoc_fn)
