/*typ*//* #import "/lib.typ": nestoc, nestemp; #let nestoc_fn(heading_offset:0) = (
  title: "API",
  author: "xieby1",
  abstract: [
    Nestoc的所有功能围绕着函数
    ```typ #nestoc(nestoc_fn, heading_offset, template0, templateN) => body```
    展开。
  ],
  body: [
*/

// TODO: API check
#import "./nestemp/lib.typ" as nestemp

/*typ*//*
  = ```typc nestoc(nestoc_fn, heading_offset:0, template0:nestemp.template0, templateN:nestemp,templateN) => body```

  对`nestoc_fn`包含的文档内容施加`heading_offset`的偏移。
  然后根据`heading_offset`施加样式：若`heading_offset==0`则应用样式`template0`，否则应用样式`templateN`。

  - / 参数`nestoc_fn`: 为函数，见@chap:nestoc_fn
  - / 参数`heading_offset`: 为int，表示给`nestoc_fn`的题目和标题施加`heading_offset`的偏移。
    例如：
    - / ```typc heading_offset:0```: 表示不偏移
    - / ```typc heading_offset:1```: 表示`nestoc_fn`题目=>一级标题，`nestoc_fn`的一级标题=>二级标题，...
    - / ```typc heading_offset:2```: 表示`nestoc_fn`题目=>二级标题，`nestoc_fn`的一级标题=>三级标题，...
  - / 参数```typc template0```: 为函数，见@chap:template0
  - / 参数```typc templateN```: 为函数，见@chap:templateN
  - / 返回值: 为文档内容
*/
#let nestoc(nestoc_fn, heading_offset: 0, template0: nestemp.template0, templateN: nestemp.templateN) = {
  /*typ*//*
    // TODO: remove indentation
    = ```typc nestoc_fn(heading_offset:0) => nestoc_obj``` <chap:nestoc_fn>

    - / 参数`heading_offset`: 同`nestoc`的`heading_offset`
    - / 返回值`nestoc_obj`: 为字典类型，有如下成员变量：
      - / `title`: 字符串类型，文档的题目
      - / `author`: 字符串类型，作者
      - / `abstract`: 文档类型，摘要
      - / `body`: 文档内容
  */
  let nestoc_obj = nestoc_fn(heading_offset: heading_offset)
  let body = nestoc_obj.remove("body")
  if heading_offset == 0 {
    /*typ*//*
      = ```typc template0(title:"", author:"", abstract:[], body) => styled_body``` <chap:template0>

      - / 参数`title`: 标题字符串
      - / 参数`author`: 作者字符串
      - / 参数`abstract`: 摘要内容
      - / 参数`body`: 文档内容
      - / 返回值: 应用了模板之后的文档内容
    */
    template0(..nestoc_obj, body)
  } else {
    /*typ*//*
      = ```typc templateN(heading_offset, title:"", author:"", abstract:[], body) => styled_body``` <chap:templateN>

      比`templateN`多了参数`heading_offset`。其他参数含义一致。
    */
    templateN(heading_offset, ..nestoc_obj, body)
  }
}

/*typ*//* ]); #nestoc(nestoc_fn) */
