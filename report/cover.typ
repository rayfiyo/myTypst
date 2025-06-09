#let cover(title, exp_no, exp_date) = {
  align(center + horizon)[
    #set text(size: 18pt)

    #text([実験番号: #exp_no])

    #text(title, size: 36pt)

    #text([サブタイトル])

    #v(60pt)

    #text([著 者])

    #text(size: 16pt, [実験日: #exp_date])

    #text(size: 16pt, [作成日:
      #datetime.today().year() 年
      #datetime.today().month() 月
      #datetime.today().day() 日])
  ]

  pagebreak()
}
