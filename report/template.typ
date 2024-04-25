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
              counters.at(identifier) = (..bc, 1)
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

    // Configure paragraph properties.
    set text(size: 12pt)
    set par(leading: 0.8em, first-line-indent: 20pt, justify: true)
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
// Delete outlines as they are not needed.

// Definition of image outline
// Delete outlines as they are not needed.

// Definition of table outline
// Delete outlines as they are not needed.

// Setting empty par
#let empty_par() = {
  v(-1em)
  box()
}

// Construction of paper
#let master_thesis(
  // The master thesis title.
  title: "ここにtitleが入る",
  // The paper`s author.
  author: "ここに著者が入る",
  // The author's information
  university: "", school: "", department: "", id: "", mentor: "", mentor-post: "", class: "修士", date: (
    datetime.today().year(), datetime.today().month(), datetime.today().day(),
  ), paper-type: "論文",
  // Abstruct
  abstract_ja: [], abstract_en: [], keywords_ja: (), keywords_en: (),
  // The paper size to use.
  paper-size: "a4",
  // The path to a bibliography file if you want to cite some external works.
  bibliography-file: none, enable_toc_of_image: true, enable_toc_of_table: true,
  // The paper's content.
  body,
) = {
  // Set the document's metadata.
  set document(title: title, author: author)
  // Set the body font. TeX Gyre Pagella is a free alternative
  // to Palatino.
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

  // counting caption
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
  align(center)[
    #v(80pt)
    #text(size: 16pt)[
      #university #school #department
    ]

    #text(size: 16pt)[
      #class#paper-type
    ]

    #v(40pt)
    #text(size: 22pt, weight: "bold")[
      #title
    ]

    #v(50pt)
    #text(size: 16pt)[
      #id #author
    ]

    #if (mentor != "" or mentor-post != "") {
      text(size: 16pt)[
        指導教員: #mentor #mentor-post
      ]
    }

    #v(40pt)
    #text(size: 16pt)[
      #date.at(0) 年 #date.at(1) 月 #date.at(2) 日 提出
    ]
    #pagebreak()
  ]

  set page(footer: [
    #align(center)[#counter(page).display("i")]
  ])

  counter(page).update(1)
  // Show abstruct
  abstract_page(
    abstract_ja, abstract_en, keywords_ja: keywords_ja, keywords_en: keywords_en,
  )
  pagebreak()

  // Configure paragraph properties.
  set par(leading: 0.8em, first-line-indent: 20pt, justify: true)
  show par: set block(spacing: 1.2em)

  // Configure chapter headings.
  set heading(numbering: (..nums) => {
    if nums.pos().len() == 1 {
      return [第 #nums.pos().map(str).join(".") 章]
    } else {
      return [#nums.pos().map(str).join(".") #h(0.5em)]
    }
  })

  let before_h1(it) = if it.numbering != none {
    text()[
      #numbering(it.numbering, ..counter(heading).at(it.location()))
      #h(1em)
    ]
  }

  show heading.where(level: 1): it => {
    pagebreak()
    counter(math.equation).update(0)
    set text(weight: "medium", size: font_sizes.at("h1"))
    set block(spacing: 1.5em)
    text()[
      #v(10pt)
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
  toc()
  if enable_toc_of_image or enable_toc_of_table {
    pagebreak()
  }
  if enable_toc_of_image {
    toc_image()
  }
  if enable_toc_of_table {
    toc_table()
  }

  // Start main pages.
  set page(footer: [
    #align(center)[#counter(page).display("1")]
  ])

  counter(page).update(1)

  set math.equation(supplement: [式], numbering: equation_num)

  body

  // Display bibliography.
  if bibliography-file != none {
    show bibliography: set text(12pt)
    bibliography(bibliography-file, title: "参考文献", style: "chicago-author-date")
  }
}

// LATEX character
#let LATEX = {
  [L];box(move(dx: -4.2pt, dy: -1.2pt, box(scale(65%)[A])));box(move(dx: -5.7pt, dy: 0pt, [T]));box(move(dx: -7.0pt, dy: 2.7pt, box(scale(100%)[E])));box(move(dx: -8.0pt, dy: 0pt, [X]));h(-8.0pt)
}
