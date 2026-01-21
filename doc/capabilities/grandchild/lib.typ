#let nestoc_fn(
  heading_offset: 0,
) = (
title: "孙模块的题目 `grandchild/main.typ`",
author: "xieby3",
heading_offset: heading_offset,
content: [
#set heading(offset: heading_offset)

= 孙模块的一级标题

#table(
  columns: (auto, auto, auto, auto),
  table.header([`grandchild/main.typ`], [`capabilities/main.typ`], [`doc/main.typ`], [总文档]),
  [题目], [三级标题], [五级标题], [二级标题],
  [一级标题], [四级标题], [六级标题], [三级标题],
  [..], [..], [..], [..]
)
])
