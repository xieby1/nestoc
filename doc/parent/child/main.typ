#import "../../../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "子模块的题目",
author: "xieby1",
chapter-pagebreak: false,
body: [

子模块被嵌入到父模块的题目之下。
因此相对父模块，子模块的标题等级都会+1，
这个现象能在父模块文档中观察到。
当然，子模块间接地随着父模块被嵌套到了总文档中。
相对总文档，子模块的标题登记都会+3
于是有映射关系如下：

#table(
  columns: 3,
  [*子模块*], [*父模块*], [*总文档*],
  [题目]    , [一级标题], [三级标题],
  [一级标题], [二级标题], [四级标题],
  [..]      , [..]      , [..]      ,
)

= 子模块的一级标题

子模块的一级标题下方的内容

#{
  import "./grandchild/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+1)
}

])
#nestoc(nestoc_fn)
