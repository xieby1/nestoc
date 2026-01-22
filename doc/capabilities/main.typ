#import "../../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "Nestoc 能力展示",
author: "xieby2",
abstract: [
  用 Nestoc 的文档 `doc/` 作为例子，
  展示 Nestoc 的模块和嵌套的能力。
],
body: [
Nestoc 的 `doc/` 目录包含了模块化的文档。
其模块层次如下

- `doc/main.typ`
  - `capabilities/main.typ`
    - `grandchild/main.typ`

#{
  import "./parent/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+1)
}
])
#nestoc(nestoc_fn)
