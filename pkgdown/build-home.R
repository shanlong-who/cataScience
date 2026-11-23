# Keep the pkgdown package overview and give first-time learners their own homepage.
build_home <- function(destination, chinese) {
  root <- if (chinese) file.path(destination, "zh") else destination
  asset <- if (chinese) "../" else ""
  base.url <- "https://shanlong-who.github.io/cataScience/"
  url <- if (chinese) paste0(base.url, "zh/") else base.url
  guide <- if (chinese) "技术首页" else "Technical guide"
  classroom <- paste0("https://shanlong-who.github.io/cata/?lang=", if (chinese) "zh" else "en")
  version <- unname(read.dcf("DESCRIPTION", fields = "Version")[1L])
  copy <- if (chinese) {
    c(language = "zh-CN", title = "在猫咖学数据科学", headline = "在猫咖，", accent = "学数据科学。",
      description = "你接手了一家有 31 只猫的猫咖。用两张表核对它们的身长和体重，比较不同性格的猫，再用一张图向别人讲清你的发现。",
      enter = "进入中文课堂", browser = "在浏览器中学习，无需安装 R。首次打开需要下载课堂。",
      badges = "R 包状态", badge.version = "CRAN 正式版", badge.downloads = "CRAN 累计下载量",
      badge.check = "查看 R CMD check 结果", badge.lifecycle = "项目成熟度：成熟",
      alt = "善龙的两只虎斑猫，一只眯着眼，另一只靠在它身边。", caption = "善龙的两只猫",
      skip = "跳到正文", nav = "网站导航", other = "English", other.path = "../index.html",
      exercise = "试做一道课堂练习", question = "Stanley 真的有 56 公斤吗？",
      instruction = "表里写着 56 公斤。你会把这一行删掉、把体重调低，还是先查原始记录？",
      reveal = "核对 Stanley 的原始记录", answer = "原表把小数点漏掉了。在课堂里，你可以亲手输入 5.6，保留原来的 56，再用核实后的体重作图。",
      data.title = "两份课堂原表", data.intro = "想先用 Excel 看一眼？两份表各有 31 只猫，可以用猫的 ID 对应起来。",
      measures = "猫的名字、体重与身长", traits = "猫的品种、毛色与性格",
      more = "继续学习", first = "课堂入门", first.text = "载入示例数据，找到清理、作图、AI 练习和测验。",
      workflow = "数据质量练习", workflow.text = "比较清理方法，检查关联键，解释图表中的分母。",
      guide.text = "在 R 中安装 cataScience、启动课堂、查阅函数和示例。", news = "版本记录")
  } else {
    c(language = "en", title = "Learn data science in a cat café", headline = "Learn data science", accent = "in a cat café.",
      description = "You run a café with 31 cats. Use two tables to check their measurements, compare their personalities and explain what you find in a chart.",
      enter = "Open the classroom", browser = "Runs in your browser. Allow time for the first download.",
      badges = "R package status", badge.version = "Current CRAN version", badge.downloads = "Total CRAN downloads",
      badge.check = "View R CMD check results", badge.lifecycle = "Lifecycle: mature",
      alt = "An illustration of Shanlong’s two tabby cats nestled together.", caption = "Shanlong’s two cats",
      skip = "Skip to content", nav = "Site navigation", other = "中文", other.path = "zh/index.html",
      exercise = "Try a classroom exercise", question = "Does Stanley really weigh 56 kg?",
      instruction = "His row says 56 kg. Would you remove it, cap the weight or check the original record first?",
      reveal = "Check Stanley’s original record", answer = "A decimal point was missing. In the classroom you can enter 5.6, keep the original 56 and plot the verified weight.",
      data.title = "The two classroom workbooks", data.intro = "Prefer to start in Excel? Both sheets contain the same 31 cats, matched by cat ID.",
      measures = "Cat names and measurements", traits = "Breeds, colours and personalities",
      more = "Keep learning", first = "Getting started", first.text = "Load the sample data and find the cleaning, charting, AI and quiz activities.",
      workflow = "Data quality in practice", workflow.text = "Compare cleaning choices, check join keys and explain chart denominators.",
      guide.text = "Install cataScience in R, launch the app and look up functions and examples.", news = "Release notes")
  }

  index <- file.path(root, "index.html")
  technical <- xml2::read_html(index, encoding = "UTF-8")
  title <- paste(guide, "· cataScience")
  xml2::xml_set_text(xml2::xml_find_first(technical, "//title"), title)
  xml2::xml_set_attr(xml2::xml_find_all(technical, "//meta[@property='og:title']"), "content", title)
  xml2::xml_add_child(xml2::xml_find_first(technical, "//head"), "link",
    rel = "canonical", href = paste0(url, "technical.html"))
  xml2::write_html(technical, file.path(root, "technical.html"))
  values <- c(copy, asset = asset, url = url, classroom = classroom, guide = guide,
    version = version, image.url = paste0(base.url, "landing/cats.webp"))
  template <- paste(readLines("pkgdown/landing/index.html", encoding = "UTF-8"), collapse = "\n")
  html <- stringr::str_replace_all(template, "\\{\\{ [a-z.]+ \\}\\}", function(matches) {
    keys <- substring(matches, 4L, nchar(matches) - 3L)
    stopifnot(all(keys %in% names(values)))
    htmltools::htmlEscape(unname(values[keys]), attribute = TRUE)
  })
  writeLines(enc2utf8(html), index, useBytes = TRUE)
  markdown <- file.path(root, "index.md")
  if (file.exists(markdown)) {
    fs::file_copy(markdown, file.path(root, "technical.md"), overwrite = TRUE)
    links <- c(classroom, paste0(url, "technical.html"))
    labels <- c(copy[["enter"]], guide)
    writeLines(enc2utf8(c(paste("#", copy[["title"]]), "", copy[["description"]], "",
      sprintf("- [%s](%s)", labels, links))), markdown, useBytes = TRUE)
  }
  sitemap <- file.path(root, "sitemap.xml")
  if (file.exists(sitemap)) {
    doc <- xml2::read_xml(sitemap)
    tech.url <- paste0(url, "technical.html")
    if (!tech.url %in% xml2::xml_text(xml2::xml_find_all(doc, "//*[local-name()='loc']"))) {
      xml2::xml_add_child(xml2::xml_add_child(xml2::xml_root(doc), "url"), "loc", tech.url)
      xml2::write_xml(doc, sitemap)
    }
  }
}
