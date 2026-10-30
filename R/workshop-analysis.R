#' Reproduce the synthetic Lao workshop analysis
#'
#' Uses the bundled B/C reference files and the declared course selection
#' policy. This is a worked teaching example, not a national estimate or a
#' general clinical analysis function. Reported testing is distinct from
#' result availability and viral suppression.
#' @return A list of joined and selected records, join audit, status summary,
#'   analysis flow, chi-square test, logistic models and an odds-ratio table.
#'   Ordinary model intervals ignore within-facility correlation.
#' @export
#' @examples
#' lesson <- cata_lao_analysis()
#' lesson$flow
cata_lao_analysis <- function() {
  b <- cata_example("art")
  facilities <- cata_example("facilities")
  names(b)[names(b) == "district"] <- "patient_district"
  names(facilities)[names(facilities) == "district"] <- "facility_district"
  joined <- cata_join(b, facilities, by = "facility_id")
  data <- joined$data
  selected <- data[data$record_action == "retain" & !data$age_review & !data$art_review, , drop = FALSE]
  summary <- cata_count_status(selected, "vl_tested", by = "facility_type")
  sex <- selected[selected$sex_standard %in% c("Female", "Male"), , drop = FALSE]
  known <- sex[sex$vl_tested %in% c("Yes", "No"), , drop = FALSE]
  known$sex_standard <- factor(known$sex_standard, levels = c("Female", "Male"))
  chi.table <- table(Sex = known$sex_standard, Reported_VL = factor(known$vl_tested, levels = c("No", "Yes")))
  chi <- stats::chisq.test(chi.table)
  predictors <- c("sex_standard", "age_analysis", "art_months", "facility_type")
  model.data <- known[stats::complete.cases(known[predictors]), , drop = FALSE]
  model.data$vl_event <- as.integer(model.data$vl_tested == "Yes")
  model.data$age_10y <- model.data$age_analysis / 10
  model.data$art_years <- model.data$art_months / 12
  model.data$facility_type <- factor(model.data$facility_type, levels = c("Health Center", "Hospital"))
  crude <- stats::glm(vl_event ~ sex_standard, data = model.data, family = stats::binomial(), na.action = stats::na.fail)
  adjusted <- stats::glm(vl_event ~ sex_standard + age_10y + art_years + facility_type,
                          data = model.data, family = stats::binomial(), na.action = stats::na.fail)
  labels <- c(sex_standardMale = "Male vs Female", age_10y = "Age: per 10 years",
               art_years = "ART duration: per 12 months", facility_typeHospital = "Hospital vs Health Center")
  results <- function(fit, name) {
    coefficients <- summary(fit)$coefficients
    ci <- stats::confint.default(fit)
    keep <- rownames(coefficients) != "(Intercept)"
    tibble::tibble(model = name, term = rownames(coefficients)[keep],
      contrast = unname(labels[rownames(coefficients)[keep]]),
      estimate = unname(exp(coefficients[keep, 1])), lower = unname(exp(ci[keep, 1])), upper = unname(exp(ci[keep, 2])),
      p_value = unname(coefficients[keep, 4]), records = stats::nobs(fit))
  }
  flow <- tibble::tibble(stage = c("Imported B records", "After many-to-one join", "After review policy",
    "Known Female/Male", "Known Yes/No", "Complete model predictors"),
    records = c(nrow(b), nrow(data), nrow(selected), nrow(sex), nrow(known), nrow(model.data)))
  list(joined = data, selected = selected, join_audit = joined$audit, unmatched = joined$unmatched_left,
    summary = summary, flow = flow, chi_table = chi.table, chi_square = chi,
    model_data = model.data, crude = crude, adjusted = adjusted,
    odds_ratios = dplyr::bind_rows(results(crude, "Crude"), results(adjusted, "Adjusted")))
}
