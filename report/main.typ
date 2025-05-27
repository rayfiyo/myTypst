#import "@preview/codelst:2.0.2": sourcecode, sourcefile, lineref, code-frame
#import "@preview/cjk-unbreak:0.1.0": remove-cjk-break-space

#let font_sizes = (h1: 18pt, h2: 16pt, h3: 14pt, h4: 12pt, normal: 11pt, math: 12pt)
#let code_fonts = ("UDEV Gothic 35NF")
#let math_fonts = ("New Computer Modern Math")
#let serif_fonts = ("New Computer Modern", "Noto Serif CJK JP", "IPAexMincho",)
#let sans_fonts = ("Noto Sans CJK JP", "IPAexGothic")
#let leading_size = 1.0em
#let spacing_size = 1.2em

#set heading(numbering: "1.")
#set math.equation(supplement: "式", numbering: numbering.with("(1.1)"))
#set text(font: serif_fonts, size: font_sizes.normal)
#set par(
  first-line-indent: 1em, leading: leading_size, spacing: spacing_size, justify: true,
)
#set page(
  paper: "a4", columns: 1, margin: (bottom: 1.75cm, top: 2.5cm, left: 2cm, right: 2cm),
)

#show figure.where(kind: image): set figure(supplement: "図")
#show figure.where(kind: table): set figure(supplement: "表")
#show math.equation: set text(font: math_fonts, size: font_sizes.math)
#show raw: set text(font: code_fonts, size: font_sizes.normal)
#show heading: it => {
  par(text(size: 0pt, "")); v(- spacing_size / 2)
  text(font: sans_fonts, weight: "medium")[#it]
  par(text(size: 0pt, "")); v(- spacing_size / 2)
}
#show: remove-cjk-break-space // from @preview/cjk-unbreak

// 表紙

#align(center + horizon)[
  #set text(size: font_sizes.at("h1"))

  #text([タイトル], size: 36pt)

  #text([サブタイトル])

  #v(60pt)

  #text([著 者])

  #text(size: 16pt)[
    #datetime.today().year() 年
    #datetime.today().month() 月
    #datetime.today().day() 日
  ]
]

#pagebreak()

// 本文

= 概要

= 実験目的

= 実験原理

= 実験方法と手順

= 使用器具

= 実験結果

= 考察

#bibliography("references.yml", title: "参考文献", style: "ieee")

// チートシート: https://github.com/rayfiyo/my-typst/blob/main/note/main.typ
// = チートシート
//
// - コードブロック
//   #sourcecode(numbers-start: 1)[```c #include <stdio.h> ```]
// - 数式 と 引用
//   $ A = mat(1, 2;3, 4) $ <eq1>
//   @eq1 を表示（引用）
// - 表 と 引用
//   #figure(
//     table(
//       columns: (7em, auto), align: (left, left), inset: 10pt, // columns: 2, なども可
//       [名称], [値], //
//       [A], [2], //
//       [B], [6], //
//     ),
//   ) <tbl1>
//   @tbl1 を表示（引用）
// - URL埋め込み
//   #link("https://typst.app/docs")[公式ドキュメント]
// - 画像 と 引用
//   #figure(image("images/hoge.png", width: 80%), caption: [ 分圧のグラフ ]) <img1>
//   @img1 を表示（引用）
// - *太い赤字*<r>
