#import "./template.typ": *
#import "@preview/codelst:2.0.0": sourcecode, sourcefile, lineref, code-frame
#show: master_thesis.with(bibliography-file: "references.bib")

= メモ

// = 参考文献 // 自動生成

= チートシート

== コードブロック

#sourcecode(numbers-start: 1)[```c
    #include <stdio.h>

    int main() {
        printf("Hello, World!\n");
        return 0;
    }
```]

// #sourcefile(read("ぱす"), file:"ファイル名")

== 引用

// @ss8843592

== 数式

$ A = mat(1, 2;3, 4) $ <eq1>
// @eq1 を表示

== 画像

#img(
  image("appendix/images/ladder.svg", width: 20%), caption: [オリジナルのThe Go gopher（Gopherくん）は、Renée
    Frenchによってデザインされました。],
) <img1>\
@img1 を表示

== 表

#tbl(
  table(columns: 4, [t], [1], [2], [3], [y], [0.3s], [0.4s], [0.8s]), caption: [テーブル],
) <tbl1>
@tbl1 を表示

== URL埋め込み

#link("https://typst.app/docs")[公式ドキュメント]

== 定理

#let theorem = thmbox("theorem", "定理", base_level: 1)

#theorem("ヲイラ-")[
  Typst はすごいのである.
] <theorem>

== 補題

#let lemma = thmbox("theorem", "補題", base_level: 1)

#lemma[
  Texはさようならである.
] <lemma>

== 定義

#let definition = thmbox("definition", "定義", base_level: 1, stroke: black + 1pt)

#definition[
  Typst is a new markup-based typesetting system for the sciences.
] <definition>
