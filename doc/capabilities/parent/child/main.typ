#import "../../../../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "子模块的题目",
author: "xieby1",
chapter-pagebreak: false,
body: [

子模块被嵌入到父模块的题目之下。
因此相对父模块，子模块的标题等级都会+1。
相对总文档，子模块的标题登记都会+4
于是有映射关系如下：

#table(
  columns: (auto, auto, auto),
  table.header([`child/main.typ`], [`parent/main.typ`], [..], [总文档]),
  [题目], [..], [三级标题],
  [一级标题], [..], [四级标题],
  [..], [..], [..],
)

= 子模块的一级标题

子模块的一级标题下方的内容

#{
  import "./grandchild/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+1)
}

])
#nestoc(nestoc_fn)
