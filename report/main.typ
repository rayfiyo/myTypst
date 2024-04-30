#import "./template.typ": *
#show: master_thesis.with(
  title: "Typstで書く修論のテンプレ", author: "右往 左往", university: "東京大学大学院", school: "工学系研究科", department: "航空宇宙工学専攻", id: "12-345678", mentor: "魚 竿", mentor-post: "准教授", class: "修士", member: "hoge男", abstract_ja: [
    近年の宇宙ってほんますごい. 近年の宇宙ってほんますごい.
    近年の宇宙ってほんますごい. 近年の宇宙ってほんますごい.
    近年の宇宙ってほんますごい. 近年の宇宙ってほんますごい.
    近年の宇宙ってほんますごい. 近年の宇宙ってほんますごい.
    近年の宇宙ってほんますごい. 近年の宇宙ってほんますごい.
    近年の宇宙ってほんますごい.
  ], bibliography-file: "references.bib",
)

= 実験目的
= 実験原理
= 実験方法と手順
= 使用器具
= 実験結果
= 考察
// = 参考文献 // 自動生成

= チートシート

== コードブロック
```typ
コードブロック
```

== 引用
@ss8843592

== 数式
$ A = mat(1, 2;3, 4) $ <eq1>
@eq1 を表示

== 画像
#img(
  image("appendix/images/ladder.svg", width: 20%), caption: [オリジナルのThe Go gopher（Gopherくん）は、Renée
    Frenchによってデザインされました。],
) <img1>\
@img1 を表示

== 表
#tbl(
  table(columns: 4, [t], [1], [2], [3], [y], [0.3s], [0.4s], [0.8s]), caption: [テーブル @madje2022programmable],
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
