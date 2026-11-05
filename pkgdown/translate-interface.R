# Translate generated website labels even when R's message catalog is unavailable.
# Content translations live in pkgdown/zh; code, function names and citations stay intact.
website.labels <- c(
  "Usage" = "用法", "Arguments" = "参数", "Value" = "返回值",
  "Examples" = "示例", "Details" = "详细说明", "See also" = "另请参阅",
  "References" = "参考文献", "Format" = "格式", "Source" = "来源",
  "Source:" = "来源：", "On this page" = "本页目录",
  "Links" = "链接", "View on CRAN" = "查看 CRAN 页面",
  "Browse source code" = "浏览源代码", "Report a bug" = "报告问题",
  "License" = "许可协议", "Citation" = "引用",
  "Citing cataScience" = "引用 cataScience", "Developers" = "开发者",
  "Dev status" = "开发状态", "Developed by" = "开发者：",
  "Site built with" = "网站构建工具：", "Author, maintainer" = "作者、维护者",
  ". Author, maintainer." = "。作者、维护者。",
  "Authors and Citation" = "作者与引用", "Authors" = "作者",
  "Author" = "作者", "maintainer" = "维护者",
  "Articles" = "使用指南", "All vignettes" = "全部指南",
  "Reference" = "函数参考", "Function reference" = "函数参考",
  "Changelog" = "更新记录", "News" = "更新记录",
  "Contents" = "目录", "Search site" = "搜索网站", "Search for" = "搜索",
  "Skip to contents" = "跳到正文", "Site navigation" = "网站导航",
  "Table of contents" = "目录", "Toggle navigation" = "切换导航栏",
  "Copy to clipboard" = "复制到剪贴板", "Page not found (404)" = "未找到页面（404）"
)

translate_label <- function(value) {
  key <- trimws(value)
  if (length(key) == 1L && !is.na(key) && key %in% names(website.labels)) {
    sub(key, unname(website.labels[key]), value, fixed = TRUE)
  } else {
    value
  }
}

translate_interface <- function(document) {
  nodes <- xml2::xml_find_all(document,
    "//text()[not(ancestor::pre or ancestor::code or ancestor::script or ancestor::style)]")
  for (node in nodes) xml2::xml_set_text(node, translate_label(xml2::xml_text(node)))
  for (attribute in c("aria-label", "placeholder", "title", "content")) {
    nodes <- xml2::xml_find_all(document, paste0("//*[@", attribute, "]"))
    for (node in nodes) {
      xml2::xml_set_attr(node, attribute, translate_label(xml2::xml_attr(node, attribute)))
    }
  }
  title <- xml2::xml_find_first(document, "//title")
  value <- xml2::xml_text(title)
  prefix <- sub(" • cataScience$", "", value)
  if (!identical(value, prefix)) {
    xml2::xml_set_text(title, paste0(translate_label(prefix), " • cataScience"))
  }
  document
}
