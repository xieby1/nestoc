#let nestoc_fn(
  heading_offset: 0,
) = (
title: "Nestoc 能力展示",
author: "xieby2",
abstract: [
  用 Nestoc 的文档 `doc/` 作为例子，
  展示 Nestoc 的模块和嵌套的能力。
],
heading_offset: heading_offset,
content: [
Nestoc 的 `doc/` 目录包含了模块化的文档。
其模块层次如下

- `doc/main.typ`
  - `capabilities/main.typ`

= 顶层模块 `doc/main.typ`

顶层模块到总文档的各级标题为直接映射：

#table(
  columns: (auto, auto),
  table.header([`doc/main.typ`], [总文档]),
  [题目], [题目],
  [一级标题], [一级标题],
  [..], [..]
)

= 子模块 `capabilities/main.typ`

该模块被嵌入到顶层模块的一级标题之下，即该模块的最高级标题为二级。
因此所有的标题等级都会+2。
于是有映射关系如下：

#table(
  columns: (auto, auto, auto),
  table.header([`capabilities/main.typ`], [`doc/main.typ`], [总文档]),
  [题目], [二级标题], [二级标题],
  [一级标题], [三级标题], [三级标题],
  [..], [..], [..]
)

])
