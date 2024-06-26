// Store theorem environment numbering

// Set font sizes
#let font_sizes = (h1: 18pt, h2: 16pt, h3: 14pt, under_h4: 12pt, normal: 11pt, math: 12pt)

// Store theorem environment numbering
#let thmcounters = state("thm", ("counters": ("heading": ()), "latest": ()))

// Setting theorem environment
#let thmenv(identifier, base, base_level, fmt) = {
  let global_numbering = numbering

  return (
    ..args, body, number: auto, numbering: "1.1", refnumbering: auto, supplement: identifier, base: base, base_level: base_level,
  ) => {
    let name = none
    if args != none and args.pos().len() > 0 {
      name = args.pos().first()
    }
    if refnumbering == auto {
      refnumbering = numbering
    }
    let result = none
    if number == auto and numbering == none {
      number = none
    }
    if number == auto and numbering != none {
      result = locate(loc => {
        return thmcounters.update(thmpair => {
          let counters = thmpair.at("counters")
          // Manually update heading counter
          counters.at("heading") = counter(heading).at(loc)
          if not identifier in counters.keys() {
            counters.insert(identifier, (0,))
          }

          let tc = counters.at(identifier)
          if base != none {
            let bc = counters.at(base)

            // Pad or chop the base count
            if base_level != none {
              if bc.len() < base_level {
                bc = bc + (0,) * (base_level - bc.len())
              } else if bc.len() > base_level {
                bc = bc.slice(0, base_level)
              }
            }

            // Reset counter if the base counter has updated
            if tc.slice(0, -1) == bc {
              counters.at(identifier) = (..bc, tc.last() + 1)
            } else {
              // counters.at(identifier) = (..bc, 1)
            }
          } else {
            // If we have no base counter, just count one level
            counters.at(identifier) = (tc.last() + 1,)
            let latest = counters.at(identifier)
          }

          let latest = counters.at(identifier)
          return ("counters": counters, "latest": latest)
        })
      })

      number = thmcounters.display(x => {
        return global_numbering(numbering, ..x.at("latest"))
      })
    }

    return figure(
      result + // hacky!
        fmt(name, number, body, ..args.named()) + [#metadata(identifier) <meta:thmenvcounter>], kind: "thmenv", outlined: false, caption: none, supplement: supplement, numbering: refnumbering,
    )
  }
}

// Definition of theorem box
#let thmbox(
  identifier, head, ..blockargs, supplement: auto, padding: (top: 0.5em, bottom: 0.5em), namefmt: x => [(#x)], titlefmt: strong, bodyfmt: x => x, separator: [#h(0.1em):#h(0.2em)], base: "heading", base_level: none,
) = {
  if supplement == auto {
    supplement = head
  }
  let boxfmt(name, number, body, title: auto) = {
    if not name == none {
      name = [ #namefmt(name) ]
    } else {
      name = []
    }
    if title == auto {
      title = head
    }
    if not number == none {
      title += " " + number
    }
    title = titlefmt(title)
    body = bodyfmt(body)
    pad(
      ..padding, block(
        width: 100%, inset: 1.2em, radius: 0.3em, breakable: false, ..blockargs.named(), [#title#name#separator#body],
      ),
    )
  }
  return thmenv(identifier, base, base_level, boxfmt).with(supplement: supplement)
}

// Setting plain version
#let thmplain = thmbox.with(
  padding: (top: 0em, bottom: 0em), breakable: true, inset: (top: 0em, left: 1.2em, right: 1.2em), namefmt: name => emph([(#name)]), titlefmt: emph,
)

// Counting equation number
#let equation_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter(math.equation)
    let n = c.at(loc).at(0)
    "(" + str(chapt) + "." + str(n) + ")"
  })
}

// Counting table number
#let table_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("table-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// Counting image number
#let image_num(_) = {
  locate(loc => {
    let chapt = counter(heading).at(loc).at(0)
    let c = counter("image-chapter" + str(chapt))
    let n = c.at(loc).at(0)
    str(chapt) + "." + str(n + 1)
  })
}

// Definition of table format
#let tbl(tbl, caption: "") = {
  figure(
    tbl, caption: caption, supplement: [表], numbering: table_num, kind: "table",
  )
}

// Definition of image format
#let img(img, caption: "") = {
  figure(
    img, caption: caption, supplement: [図], numbering: image_num, kind: "image",
  )
}

// Definition of abstruct page
#let abstract_page(abstract_ja, abstract_en, keywords_ja: (), keywords_en: ()) = {
  if abstract_ja != [] {
    show <_ja_abstract_>: {
      align(center)[
        #text(size: 20pt, weight: "bold")[
          概 #h(5pt) 要
        ]
      ]
    }
    [= 概要 <_ja_abstract_>]

    v(10pt)

    // Configure paragraph properties in abstract page.
    set text(size: 12pt)
    set par(first-line-indent: 20pt, justify: true)
    show par: set block(spacing: 1.2em)
    abstract_ja

    if keywords_ja != () {
      par(
        first-line-indent: 0em,
      )[
        #text(
          font: ("Times New Roman", "Source Han Serif JP"), weight: "bold", size: 12pt,
        )[
          キーワード:
          #keywords_ja.join(", ")
        ]
      ]
    }
    // pagebreak()
  }
  if abstract_en != [] {
    show <_en_abstract_>: {
      align(center)[
        #text(size: 18pt, "Abstruct")
      ]
    }
    [= Abstract <_en_abstract_>]

    set text(size: 12pt)
    h(1em)
    abstract_en
    par(first-line-indent: 0em)[
      #text(weight: "bold", size: 12pt)[
        Key Words:
        #keywords_en.join("; ")
      ]
    ]
    // pagebreak()
  }
}

// Definition of content to string
#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    " "
  }
}

// Definition of chapter outline
// Delete the outline as it is not needed.

// Definition of image outline
// Delete the outline as it is not needed.

// Definition of table outline
// Delete the outline as it is not needed.

// Setting empty par
#let empty_par() = {
  v(-1em)
  box()
}

// Setting header
// ref: https://stackoverflow.com/questions/76363935/typst-header-that-changes-from-page-to-page-based-on-state
#let custom_header() = locate(
  loc => [
    #let i = counter(page).at(loc).first()
    #let ht-first = state("page-first-section", [])
    #let ht-last = state("page-last-section", [])
    // find first heading of level 1 on current page
    #let first-heading = query(heading.where(level: 1), loc).find(h => h.location().page() == loc.page())
    // find last heading of level 1 on current page
    #let last-heading = query(heading.where(level: 1), loc).rev().find(h => h.location().page() == loc.page())
    // don't show chapter numbering in header of bibliography page
    #let header-chapt-num(content) = {
      let bibliography-content = query(bibliography, loc).at(0)
      if not content.at("body") == bibliography-content.at("title") {
        return [
          #numbering(content.numbering, ..counter(heading).at(content.location()))
          #h(10pt)
        ]
      } else {
        return none
      }
    }
    // test if the find function returned none (i.e. no headings on this page)
    #{
      if first-heading != none {
        ht-first.update([
          // change style here if update needed section per section
          #header-chapt-num(first-heading)
          #first-heading.body
        ])
        ht-last.update([
          // change style here if update needed section per section
          #header-chapt-num(last-heading)
          #last-heading.body
        ])
        // if one or more headings on the page, use first heading
        // change style here if update needed page per page
        [#ht-first.display() #h(1fr)]
      } else {
        // no headings on the page, use last heading from variable
        // change style here if update needed page per page
        [#ht-last.display() #h(1fr)]
      }
    }
    #v(3pt, weak: true)
    #line(length: 100%, stroke: 0.5pt + black)
  ],
)
#let appendix(body) = {
  counter(heading).update(0) // 付録の添字リセット？
  counter("appendix").update(1)
  set heading(
    numbering: (..nums) => {
      let vals = nums.pos()
      let value = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".at(vals.at(0) - 1)
      if vals.len() == 1 {
        return [ #linebreak() 付録 #value ] // 明示的な改行含む
      } else {
        return [#(value + "." + nums.pos().slice(1).map(str).join(".")) #h(0.5em)]
      }
    },
  );
  let before_h1(it) = if it.numbering != none {
    text()[
      #v(10pt)
      #numbering(it.numbering, ..counter(heading).at(it.location()))
    ]
  } else {
    none
  }
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    set text(size: font_sizes.at("h1"))
    set block(spacing: 1.5em)
    text()[
      #before_h1(it) #h(0.5em) #it.body #v(0pt)
    ]
  }
  show heading.where(level: 2): it => block({
    set text(size: font_sizes.at("h2"))
    text()[
      #it
    ]
  })
  [#body]
}

// Construction of paper
#let cover(
  number: "",
  // The master thesis title.
  title: "",
  // The paper`s author.
  id: "", author: "",
  // The author's information
  university: "", school: "", department: "", mentor: "",
  // The Experiment environment
  room: "", exp_year: "", exp_month: "", exp_day: "", exp_day_of_week: "", //
  weather: "", temperature: "", humidity: "", atmospheric_pressure: "", //
  group: "", member1: "", member2: "", member3: "", member4: "", member5: "", member6: "", //
  date: (
    datetime.today().year(), datetime.today().month(), datetime.today().day(),
  ), //
  purpose: [
  ],
  // Abstruct
  abstract_ja: [
  ],
  // The paper size to use.
  paper-size: "a4",
  // The path to a bibliography file if you want to cite some external works.
  bibliography-file: none, enable_toc_of_image: true, enable_toc_of_table: true,
  // The paper's content.
  body,
) = {
  // Set the document's metadata.
  set document(title: title, author: author)
  // Set the body font. TeX Gyre Pagella is a free alternative to Palatino.
  set text(
    font: ("Noto Serif CJK JP", "Times New Roman", "Source Han Serif JP"), size: font_sizes.at("normal"),
  )
  show strong: set text(font: ("Noto Serif CJK JP", "Times New Roman", "IPAPGothic"))
  // Set font size
  show footnote.entry: set text(10pt)
  show footnote: set text(15pt)
  show math.equation: set text(font_sizes.at("math"))
  set list(indent: 7pt)
  set enum(indent: 7pt)

  // Configure the page properties.
  set page(
    paper: paper-size, margin: (bottom: 1.75cm, top: 2.5cm, left: 2cm, right: 2cm),
  )

  // citation number
  show ref: it => {
    if it.element != none and it.element.func() == figure {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)

      link(
        loc,
      )[#if el.kind == "image" or el.kind == "table" {
          // counting
          let num = counter(el.kind + "-chapter" + str(chapt)).at(loc).at(0) + 1
          it.element.supplement
          " "
          str(chapt)
          "."
          str(num)
        } else if el.kind == "thmenv" {
          let thms = query(selector(<meta:thmenvcounter>).after(loc), loc)
          let number = thmcounters.at(thms.first().location()).at("latest")
          it.element.supplement
          " "
          numbering(it.element.numbering, ..number)
        } else {
          it
        }
      ]
    } else if it.element != none and it.element.func() == math.equation {
      let el = it.element
      let loc = el.location()
      let chapt = counter(heading).at(loc).at(0)
      let num = counter(math.equation).at(loc).at(0)

      it.element.supplement
      " ("
      str(chapt)
      "."
      str(num)
      ")"
    } else if it.element != none and it.element.func() == heading {
      let el = it.element
      let loc = el.location()
      let num = numbering(el.numbering, ..counter(heading).at(loc))
      if el.level == 1 {
        str(num)
        "章"
      } else if el.level == 2 {
        str(num)
        "節"
      } else if el.level == 3 {
        str(num)
        "項"
      }
    } else {
      it
    }
  }

  // counting caption numbe
  show figure: it => {
    set align(center)
    if it.kind == "image" {
      set text(size: 12pt)
      it.body
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("image-chapter" + str(chapt))
        c.step()
      })
    } else if it.kind == "table" {
      set text(size: 12pt)
      it.supplement
      " " + it.counter.display(it.numbering)
      " " + it.caption.body
      set text(size: 10.5pt)
      it.body
      locate(loc => {
        let chapt = counter(heading).at(loc).at(0)
        let c = counter("table-chapter" + str(chapt))
        c.step()
      })
    } else {
      it
    }
  }

  // Display inline code (in a small box)
  show raw.where(block: false): box.with(
    fill: luma(240), inset: (x: 3pt, y: 0pt), outset: (y: 3pt), radius: 2pt,
  )

  // Display block code (in a larger block with more padding)
  show raw.where(block: true): block.with(fill: luma(240), inset: 10pt, radius: 4pt, width: 100%)

  // The first page.
  place(
    top + left, dx: 3.297%, dy: 2.156%,
  )[
    #set text(
      font: (
        "UD Digi Kyokasho N-R", "Noto Serif CJK JP", "Times New Roman", "IPAPGothic",
      ),
    )
    #rect(
      width: 98.29%, height: 97.6%, stroke: 2.86pt, radius: 1.3pt,
    )[
      #place(
        dx: -5pt, dy: -5pt, align(
          horizon + center,
        )[
          #grid(
            columns: (25.511%, 42.586%, 34.1%), //
            rect(
              width: 100%, height: 8.12%, stroke: (left: 0pt, rest: 1.56pt), radius: (top-left: 1pt),
            )[#text(size: 28pt)[ #number ]], //
            rect(
              width: 100%, height: 8.12%, stroke: (left: 0pt, rest: 1.56pt),
            )[#text(size: 24pt, tracking: 8pt, weight: "black")[ 実験報告書 ]], //
            rect(
              width: 100%, height: 8.12%, stroke: (left: 0pt, rest: 1.56pt),
            )[ #university \ #school \ #department ], //
          )
        ],
      )
      #place(
        dx: -5pt, dy: -5pt, [#rect(
            width: 9.1%, height: 4.06%, stroke: 1.4pt,
          )[#align(horizon + center)[#text(size: 12.1pt, tracking: 4pt)[ 分類 ]]]],
      )
      #place(
        dx: -5pt, dy: 52.1pt, [#rect(
            width: 102%, height: 46.6%, stroke: (bottom: 1.4pt, rest: 0pt),
          )[#place(
              dx: 37.29pt,
            )[
              #grid(
                rows: ( // TODO: % to pt
                  11.51%, 5%, 11.23%, 4.956%, 4.78%, 6.007%, 1.9%, 5.3%, // ～天候
                  4.7%, 5.0%, 4.1%, 4.88%, 4.7%, 5.2%, // 共同実験者
                  4.6%, 4.6%, 13.5pt, 19.26pt, // 提出日～
                ), [], // TODO: [#place to place
                // TODO: 最初の dy: 0pt をちゃんとやる
                [#place(dx: 7.29pt, dy: 0pt)[#text(tracking: 2.76pt)[題 目 #title]]], line(length: 383.8pt, stroke: (thickness: 1.45pt, cap: "round")), //
                [#place(dx: 7.29pt)[担当教員 #mentor] #place(dx: 232.679pt)[実験室 #room]], //
                line(
                  length: 383.36pt, stroke: (thickness: 1.45pt, cap: "round", dash: (197.33pt, 28.26pt, 200pt)),
                ), //
                [
                  #place(dx: 4.1pt)[実験年月日] #place(dx: 69.45pt)[令和 #exp_year 年] #place(dx: 168.67pt)[#exp_day 月] #place(dx: 252.3pt)[#exp_month 日] #place(dx: 296.09pt)[#exp_day_of_week 曜 ]
                  // #place(dx: 4.1pt)[実験年月日] #place(dx: 69.45pt)[令和 #exp_year 年] #place(dx: 208.67pt)[#exp_day 月] #place(dx: 252.3pt)[#exp_month 日] #place(dx: 296.09pt)[#exp_day_of_week 曜 ]
                ], //
                line(length: 335.43pt, stroke: (thickness: 1.45pt, cap: "round")), //
                [#place(
                    dx: 11.9pt,
                  )[
                    #place()[天候 #weather] #place(dx: 57.6pt)[温度 #temperature °Ｃ] #place(dx: 151.6pt)[湿度 #humidity ％] #place(dx: 246.23pt)[気圧 #atmospheric_pressure hPa]
                  ]], line(length: 383.8pt, stroke: (thickness: 1.45pt, cap: "round")), //
                [#place(dx: 7.6pt)[共同実験者 第 #group 班]], line(length: 146.8pt, stroke: (thickness: 1.45pt, cap: "round")), //
                [#place(dx: 7.46pt)[#member1] #place(dx: 139.46pt)[#member2] #place(dx: 269.46pt)[#member3]], //
                line(
                  length: 383.8pt, stroke: (thickness: 1.45pt, cap: "round", dash: (118.62pt, 14pt)),
                ), //
                [#place(dx: 7.46pt)[#member4] #place(dx: 139.46pt)[#member5] #place(dx: 269.46pt)[#member6]], //
                line(
                  length: 383.8pt, stroke: (thickness: 1.45pt, cap: "round", dash: (118.62pt, 14pt)),
                ), //
                [#place(
                    dx: 3.78pt,
                  )[#text()[提出年月日 #date.at(0) 年 #date.at(1) 月 #date.at(2) 日]]], line(length: 383.8pt, stroke: (thickness: 1.45pt, cap: "round")), //
                [#place(dx: 3.78pt)[#text()[提出者 #id #author]]], line(length: 383.8pt, stroke: (thickness: 1.45pt, cap: "round")), //
                // [#place(dx: -11.2pt)[#text()[提出者 #id #author]]], line(length: 383.8pt, stroke: (thickness: 1.45pt, cap: "round")), //
              )
            ]
          ] ],
      )
      #place(top, dx: -5pt, dy: 375.6pt, [
        #rect(width: 9.2%, height: 4%, stroke: 1.4pt)[
          #align(horizon + center)[#text(size: 12.1pt, tracking: 4pt)[ 概要 ]]
        ]
      ])
      #place(
        top, dx: 8.6pt, dy: 403.7pt, [
          #rect(
            width: 97%, height: 60%, stroke: 0pt,
          )[
            #grid(
              columns: 100%, rows: (19.1pt, 8pt, 52.781pt, 15.4pt, 8pt), //
              place(dx: 0pt, dy: 3.6pt)[#text()[実験の目的]], //
              place(dx: -4.78pt)[
                #line(length: 62pt, stroke: (thickness: 1.45pt, cap: "round"))
              ], //
              place(
                dx: 3.78pt,
              )[#text(
                  size: 10pt, font: ("Noto Serif CJK JP", "Times New Roman", "IPAPGothic"),
                )[#purpose]],
              //
              place(dx: -3.9pt)[#text()[実験と結果の概要]], //
              place(dx: -4.8pt)[
                #line(length: 89pt, stroke: (thickness: 1.45pt, cap: "round"))
              ], //
              place(
                dx: 3.78pt,
              )[#text(
                  size: 10pt, font: ("Noto Serif CJK JP", "Times New Roman", "IPAPGothic"),
                )[#purpose]],
            )
          ]
        ],
      )
    ]
  ] /*

                                                          // ローマ数字でのページ数（概要など）
                                                          set page(footer: [
                                                            #align(center)[#counter(page).display("i")]
                                                          ])

                                                          counter(page).update(1)

                                                          // 概要を表紙の次のページに書きたい場合は以下を有効化

                                                          // Show abstruct
                                                          // abstract_page(
                                                          // abstract_ja, abstract_en, keywords_ja: keywords_ja, keywords_en: keywords_en,
                                                          // )

                                                          // Configure paragraph properties. 2
                                                          set par(first-line-indent: 12pt, justify: true)

                                                          // Configure chapter headings.
                                                          set heading(numbering: (..nums) => {
                                                            if nums.pos().len() == 1 {
                                                              // 章の表示形式（フォーマット）の設定
                                                              return [#nums.pos().map(str).join(".") ．]
                                                              // return [第 #nums.pos().map(str).join(".") 章]
                                                            } else {
                                                              return [#nums.pos().map(str).join(".") #h(0.5em)]
                                                            }
                                                          })

                                                          let before_h1(it) = if it.numbering != none {
                                                            text()[
                                                              #numbering(it.numbering, ..counter(heading).at(it.location()))
                                                            ]
                                                          }

                                                          show heading.where(level: 1): it => {
                                                            // 章毎に改ページをするなら次を利用
                                                            pagebreak()
                                                            counter(math.equation).update(0)
                                                            set text(weight: "bold", size: font_sizes.at("h1"))
                                                            set block(spacing: 1.5em)
                                                            text()[
                                                              #v(-6pt)
                                                              #linebreak(justify: true) // 明示的に改行
                                                              #before_h1(it) #it.body
                                                            ]
                                                          }

                                                          show heading.where(level: 2): it => block({
                                                            set text(weight: "medium", size: font_sizes.at("h2"))
                                                            text()[
                                                              #it
                                                            ]
                                                          })

                                                          show heading.where(level: 3): it => block({
                                                            set text(weight: "medium", size: font_sizes.at("h3"))
                                                            text()[
                                                              #it
                                                            ]
                                                          })

                                                          show heading: it => {
                                                            set text(weight: "bold", size: font_sizes.at("under_h4"))
                                                            set block(above: 2em, below: 1.5em)
                                                            it
                                                          } + empty_par() // 最初の段落のインデントを下げるためにダミーの段落を設置する

                                                          // Start with a chapter outline.
                                                          if enable_toc_of_image or enable_toc_of_table {}

                                                          // Start main pages.
                                                          // アラビア数字でのページ数
                                                          set page(footer: align(center)[#counter(page).display("1")])

                                                          counter(page).update(1)

                                                          set math.equation(supplement: [式], numbering: equation_num)

                                                          body

                                                          // Display bibliography.
                                                          if bibliography-file != none {
                                                            show bibliography: set text(12pt)
                                                            bibliography(bibliography-file, title: "参考文献", style: "ieee")
                                                          }
                                                            */
}

// LATEX character
#let LATEX = {
  [L];box(move(dx: -4.2pt, dy: -1.2pt, box(scale(65%)[A])));box(move(dx: -5.7pt, dy: 0pt, [T]));box(move(dx: -7.0pt, dy: 2.7pt, box(scale(100%)[E])));box(move(dx: -8.0pt, dy: 0pt, [X]));h(-8.0pt)
}
