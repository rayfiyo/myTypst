#let cover(
  exp_no: "", title: "", sub_title: "", //
  author_id: "", author_name: "", exp_date: "", //
  edit_date: (text()[
    #datetime.today().year() 年 //
    #datetime.today().month() 月 //
    #datetime.today().day() 日 //
  ]),
) = {
  set text(size: 18pt)
  align(center + horizon)[

    #text([実験番号: #exp_no])

    #text(size: 36pt, title)

    #text(sub_title)

    #v(60pt)

    #text([著 者])

    #text(size: 16pt, [実験日: #exp_date])

    #text(size: 16pt, [作成日: #edit_date])
  ]

  pagebreak()
}
