// TODO: 自动编号：Listing => 代码块，Table => 表格，Figure => 图
#import "../lib.typ": nestoc
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "Nestoc 文档插件",
author: "xieby1",
abstract: [一个模块+嵌套的Typst文档插件。],
body: [
// TODO: add to template
// Line numbering for Raw Text / Code: https://github.com/typst/typst/issues/344
// TODO: how to customize the start line number?
// TODO: how to customize number for each line?
#show raw.where(block: true): code => {
  show raw.line: line => {
    text(fill: gray)[#line.number]
    h(1em)
    line.body
  }
  code
}
= Nestoc 简介

🪆Nestoc📑 的名称来源于 Nest（嵌套🪆）与 Doc（文档📑）的组合，亦可理解为 Nest + ToC（Table of Contents 目录）。
Nestoc 旨在构建一个支持文档嵌套（或称"模块化"）的 Typst 插件。

设想一个包含多个章节的大型文档项目，
需要由多位协作者分*模块*完成各章节内容，
最终将这些模块*嵌套*整合为统一的完整文档。

- / 模块: 每个章节均为独立、可编辑、可编译、可阅读的自包含文档。
- / 嵌套: 所有章节组合时，标题、编号等元素将自动调整，形成协调一致的最终文档。

= Nestoc 能力展示

用 Nestoc 的文档 `doc/` 作为例子，
展示 Nestoc 的模块和嵌套的能力。

Nestoc 的 `doc/` 目录包含了模块化的文档。
其模块层次如下

- 总文档：`./main.typ` => `./parent/main.pdf`
- 父模块：`./parent/main.typ` => `./parent/main.pdf`
- 子模块：`./parent/child/main.typ` => `./parent/child/main.pdf`
- 孙模块：`./parent/child/grandchild/main.typ` => `./parent/child/grandchild/main.pdf`

每个模块均可独立地编辑、编译生成pdf。
当然每个模块也可以被嵌套到其他模块中，比如grandchild被嵌套到了child里；
child被嵌套到了parent里；
parent被嵌套到了这个总文档的下面。
你可以仔细观察这些pdf文档，然后理解它们间的嵌套关系。

#{
  // Can move `import` expression to `nestoc` function?
  // No: typsts throw error: "cannot import from user-defined functions".
  import "./parent/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+2)
}

= 原理和使用

Nestoc的所有功能围绕着函数`nestoc(nestoc_fn, heading_offset:0) => body`函数展开

== `nestoc(nestoc_fn, heading_offset:0, template:default_template) => body`

- / 参数`nestoc_fn`: 为函数，其类型为`nestoc_fn(heading_offset:0) => nestoc_obj`：
- / 参数`heading_offset`: 为int，表示给`nestoc_fn`的题目和标题施加`heading_offset`的偏移。
  例如：
  - / `heading_offset:0`: 表示不偏移
  - / `heading_offset:1`: 表示`nestoc_fn`题目=>一级标题，`nestoc_fn`的一级标题=>二级标题，...
  - / `heading_offset:2`: 表示`nestoc_fn`题目=>二级标题，`nestoc_fn`的一级标题=>三级标题，...
- / 参数`template:default_template`: 模板，其类型为：\
    `template(title:"", author:"", abstract:[], body) => _body`。
    目前默认模板为修改过的#link("https://github.com/talal/ilm")[ilm] 模板。
- / 返回值: 为文档内容

== `nestoc_fn(heading_offset:0) => nestoc_obj`

- / 参数`heading_offset`: 同`nestoc`的`heading_offset`
- / 返回值`nestoc_obj`: 为字典类型，有如下成员变量：
  - / `title`: 字符串类型，文档的题目
  - / `author`: 字符串类型，作者
  - / `abstract`: 文档类型，摘要
  - / `body`: 文档内容

== `template(title:"", author:"", abstract:[], body) => _body`

- / 参数`title`: 标题字符串
- / 参数`author`: 作者字符串
- / 参数`abstract`: 摘要内容
- / 参数`body`: 文档内容
- / 返回值: 应用了模板之后的文档内容

== Nestoc文档的代码框架

每个Nestoc文档：

- 必须提供函数nestoc_fn供其他Nestoc文档调用
- 可选调用nestoc(nestoc_fn)来渲染当前文档

因此一个Nestoc文档的代码框架如下：

#figure(caption: "Nestoc文档的代码框架")[
```typst
// 定义nestoc_fn函数
#let nestoc_fn(heading_offset: 0 ) = (
title: "题目", author: "作者", abstract: [摘要], body: [
= 一级标题

正文...
])
// 调用nestoc函数，将nestoc_fn的文档内容插入于此。
#nestoc(nestoc_fn)
```
]

若用图表示上面的Nestoc文档代码框架，则如下：

#figure(caption: [Nestoc文档代码框架的图示], {
  import "@preview/fletcher:0.5.7": diagram, node, edge
  diagram(
    node((0,0), [`nestoc_fn`]),
      edge("-|>", label: [`nestoc(..)+编译`], label-side: center),
    node((3,0), [`文档.pdf`]),
  )
})

- 第1-7行定义函数`nestoc_fn(heading_offset: 0) => nestoc_obj`。
  返回的`nestoc_obj`的字典包含了`title`, `author`, `abstract`以及文档主体`body`。
- 第8-9行将上面定义的`nestoc_fn`传给`nestoc`函数。
  `nestoc`内部会进行标题级别的协调，然后调用`nestoc_fn`函数，最后返回处理好的文档主体。

你可能会好奇若不调用`nestoc(..)`函数会怎样？
则该typst文件仅是一个无法编译出pdf的模块。
这个模块仅能用于嵌入其他模块。

== 例子

本文档提供了一个具体的Nestoc例子。
本文档一共包含了4个模块。
- 每个模块均定义了自己的`nestoc_fn`函数。
- 每个模块均调用了`nestoc(自己的nestoc_fn)`。
  这让该模块可以编译成独立的pdf文档。
- 文档的嵌套通过调用`nestoc(别的模块的nestoc_fn, heading_offset: xx)`来实现。

// TODO: 引用图片编号
所有`nestoc`和`nestoc_fn`的关系如下图所示：

#figure(caption: "测试一下图", {
  import "@preview/fletcher:0.5.7": diagram, node, edge
  diagram(
    node((0,0), [`总文档nestoc_fn`], name: <top>),
      edge("-|>", label: [`nestoc(..)+编译`], label-side: center),
      node((3,0), [`总文档doc/main.pdf`], name: <top_pdf>),
    edge(<parent>, <top>, "-|>", label: [`nestoc(..)`], label-side: center),
    node((0,1), [`父模块nestoc_fn`], name: <parent>),
      edge("-|>", label: [`nestoc(..)+编译`], label-side: center),
      node((3,1), [`父文档parent/main.pdf`], name: <parent_pdf>),
    edge(<child>, <parent>, "-|>", label: [`nestoc(..)`], label-side: center),
    node((0,2), [`子模块nestoc_fn`], name: <child>),
      edge("-|>", label: [`nestoc(..)+编译`], label-side: center),
      node((3,2), [`子文档child/main.pdf`], name: <child_pdf>),
    edge(<grandchild>, <child>, "-|>", label: [`nestoc(..)`], label-side: center),
    node((0,3), [`孙模块nestoc_fn`], name: <grandchild>),
      edge("-|>", label: [`nestoc(..)+编译`], label-side: center),
      node((3,3), [`孙文档grandchild/main.pdf`], name: <grandchild_pdf>),
  )
})

])
#nestoc(nestoc_fn)
