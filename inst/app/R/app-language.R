catalogue <- utils::read.delim("www/i18n/zh.tsv", encoding = "UTF-8", sep = "\t",
  quote = "", comment.char = "", colClasses = "character", na.strings = NULL,
  stringsAsFactors = FALSE)
stopifnot(identical(names(catalogue), c("en", "zh")), !anyDuplicated(catalogue$en))
cata_dictionary <- stats::setNames(catalogue$zh, catalogue$en)

cata_session_language <- function() {
  session <- shiny::getDefaultReactiveDomain()
  if (is.null(session)) return("en")
  selected <- session$rootScope()$input$cata_language
  if (identical(selected, "zh")) "zh" else "en"
}

cata_label <- function(text, language = cata_session_language()) {
  if (!identical(language, "zh")) return(text)
  translated <- unname(cata_dictionary[text])
  ifelse(is.na(translated), text, translated)
}

# Used only for fixed statistics lessons, never for user-supplied plot labels.
cata_teaching_labs <- function(...) {
  do.call(ggplot2::labs, lapply(list(...), cata_label))
}
