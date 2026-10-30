# Export a reproducible communication project

Writes a new directory containing input and selected-data snapshots, an
R script, report and dashboard HTML, Quarto sources, and a local Shiny
dashboard. The R script reconstructs selected data using the supplied
preparation steps, then recomputes summaries and the chart. It uses an
input RDS snapshot to preserve identifiers, factors, dates and column
types.

## Usage

``` r
cata_export(
  data,
  directory,
  input = data,
  steps = character(),
  join_data = NULL,
  plot_args = NULL,
  summary_spec = NULL,
  chart_data = c("records", "summary"),
  audit = NULL,
  title = "Data analysis report",
  question = "",
  methods = "",
  finding = "",
  limitations = "",
  source = "",
  unit = "",
  denominator = "",
  width = 8,
  height = 5
)
```

## Arguments

- data:

  Selected analysis data.

- directory:

  A new output directory; existing directories are protected.

- input:

  Original input snapshot, before the listed preparation steps.

- steps:

  Character vector of R preparation statements, each operating on
  `analysis.data`. These are written to the exported script, not
  executed by this function. Only export statements you have reviewed.

- join_data:

  Optional reference-table snapshot used by preparation steps.

- plot_args:

  Named arguments for
  [`cata_plot()`](https://shanlong-who.github.io/cataScience/reference/cata_plot.md),
  excluding data.

- summary_spec:

  Optional arguments for
  [`cata_count_status()`](https://shanlong-who.github.io/cataScience/reference/cata_count_status.md),
  excluding data. The status summary is recomputed when the project is
  run.

- chart_data:

  Use selected records or the status summary for the chart.

- audit:

  Optional preparation log.

- title, question, methods, finding, limitations, source, unit,
  denominator:

  Author-supplied report text.

- width, height:

  Figure dimensions in inches, retained in the project.

## Value

The new directory, invisibly. Source files are generated even when
Quarto is not installed. HTML exports need neither Quarto nor a server.

## Examples

``` r
# \donttest{
out <- tempfile("cata-project-")
cata_export(data.frame(value = 1:5), out, title = "Example report")
# }
```
