#import "../lib.typ": nestoc, nestemp
#let nestoc_fn(
  heading_offset: 0,
) = (
title: "Nestoc 文档插件",
author: "xieby1",
abstract: [一个模块+嵌套的Typst文档插件。],
body: [
= Nestoc 简介

🪆Nestoc📑 的名称来源于 Nest（嵌套🪆）与 Doc（文档📑）的组合，亦可理解为 Nest + ToC（Table of Contents 目录）。
Nestoc 旨在构建一个支持文档嵌套（或称"模块化"）的 Typst 插件。

设想一个包含多个章节的大型文档项目，
需要由多位协作者分*模块*完成各章节内容，
最终将这些模块*嵌套*整合为统一的完整文档。

- / 模块: 每个章节均为独立、可编辑、可编译、可阅读的自包含文档。
- / 嵌套: 所有章节组合时，标题、编号等元素将自动调整，形成协调一致的最终文档。

= 使用

每个Nestoc文档：

- 必须提供函数```typc nestoc_fn```供其他Nestoc文档调用
- 可选调用```typc nestoc(nestoc_fn)```来渲染当前文档

因此一个Nestoc文档的代码框架如下：

#figure(caption: "Nestoc文档的代码框架")[
#nestemp.numbering(len:2, ```typst
// 导入nestoc
#import "@local/nestoc:0.1.0"
// 定义nestoc_fn函数
#let nestoc_fn(heading_offset: 0) = (
title: "题目", author: "作者", abstract: [摘要], body: [
= 一级标题

正文...
])
// 调用nestoc函数，将nestoc_fn的文档内容插入于此。
#nestoc.nestoc(nestoc_fn)
```)]

若用图表示上面的Nestoc文档代码框架，则如下：

#figure(caption: [Nestoc文档代码框架的图示], {
  import "@preview/fletcher:0.5.8": diagram, node, edge
  diagram(
    node((0,0), [`nestoc_fn`]),
      edge("-|>", label: [`nestoc(..)+编译`], label-side: center),
    node((3,0), [`文档.pdf`]),
  )
})

// TODO: move to doccom
- 第1-9行定义函数```typc nestoc_fn(heading_offset: 0) => nestemp_args```。
  返回的`nestemp_args`的字典包含了`title`, `author`, `abstract`以及文档主体`body`。
- 第10-11行将上面定义的`nestoc_fn`传给`nestoc`函数。
  `nestoc`内部会进行标题级别的协调，然后调用`nestoc_fn`函数，最后返回处理好的文档主体。

你可能会好奇若不调用```typc nestoc(..)```函数会怎样？
则该typst文件仅是一个无法编译出pdf的模块。
这个模块仅能用于嵌入其他模块。


TODO: 说明nix

#{
  import "com/lib.typ.typ": nestoc_fn
  nestoc(heading_offset:heading_offset+1, nestoc_fn)
}

#{
  import "com/nestemp/lib.typ.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+1)
}

= 例子

本文档提供了一个具体的Nestoc例子，包含了4个模块：
- 总文档：`doc/main.typ`
- 父模块：`doc/parent/main.typ`
- 子模块：`doc/parent/child/main.typ`
- 孙模块：`doc/parent/child/grandchild/main.typ`

这4个模块：
- 每个模块均定义了自己的`nestoc_fn`函数。
- 每个模块均调用了```typc nestoc(自己的nestoc_fn)```。
  这让该模块可以编译成独立的pdf文档。
- 文档的嵌套通过调用```typc nestoc(别的模块的nestoc_fn, heading_offset: xx)```来实现。

所有`nestoc`和`nestoc_fn`的关系如下图所示：

#figure(caption: "测试一下图", {
  import "@preview/fletcher:0.5.8": diagram, node, edge
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

grandchild被嵌套到了child里；
child被嵌套到了parent里；
parent被嵌套到了这个总文档的下面。
你可以仔细观察这些pdf文档，然后理解它们间的嵌套关系。

#{
  // Can move `import` expression to `nestoc` function?
  // No: typsts throw error: "cannot import from user-defined functions".
  import "./parent/main.typ": nestoc_fn
  nestoc(nestoc_fn, heading_offset: heading_offset+2)
}

= 其他：文档注释（Doccom）

这个算是一个方法学，
通过文档注释（Documentation + Comment => Doccom）的方式，
将文档和代码紧密结合在一起。
主要应用在底层文档，即需要和代码紧密结合的文档。

== 要解决的问题

Doccom要解决文档和代码分开而产生的问题：文档缺失、文档脱节、文档管理混乱。

== 实现方法

实现方案很简单：

- 按照特定格式在注释里写typst/markdown文档，
- 按格式文档抽取出来，
- 保存为独立的typst/markdown文档即可。

== 比较

- Doccom：简单，支持任意编程语言，任意文档语言；
- Doxygen：支持多种编程语言，但是极其复杂；
- Python/Java docstring, rustdoc, typst tidy：简单，但仅支持特定语言；

== 例子

@chap:api 和 @chap:nestemp 均采用了Doccom模式。
以 @chap:api 为例，其采用的Doccom格式为：

```typ
/*typ*//*
  Here is the typst doc.
  ...
*/
```

只需要用正则表达式将"Here is the typst doc..."的内容抽取出来即可。
@chap:api 所涉及的`lib.typ`的源码如下：

#nestemp.numbering(len:2, raw(block:true, lang:"typ", read("../lib.typ")))

])

#nestoc(nestoc_fn)
