#import "../../../../../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: [孙模块的题目],
author: "xieby3",
chapter-pagebreak: false,
heading_offset: heading_offset,
body: [
#set heading(offset: heading_offset)

#table(
  columns: (auto, auto, auto, auto),
  table.header([`grandchild/main.typ`], [`capabilities/main.typ`], [`doc/main.typ`], [总文档]),
  [题目], [三级标题], [五级标题], [二级标题],
  [一级标题], [四级标题], [六级标题], [三级标题],
  [..], [..], [..], [..]
)

= 孙模块的一级标题

孙模块的一级标题下方的内容

])
#nestoc(nestoc_fn)
