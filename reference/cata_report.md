# Write a self-contained report or dashboard

Creates a local HTML file with no online resources. Text is escaped;
narrative findings and limitations come from the author. The dashboard
includes local table search. For editable and reproducible source files,
use
[`cata_export()`](https://shanlong-who.github.io/cataScience/reference/cata_export.md).

## Usage

``` r
cata_report(
  data,
  file,
  title = "Data analysis report",
  question = "",
  methods = "",
  finding = "",
  limitations = "",
  source = "",
  unit = "",
  denominator = "",
  plot = NULL,
  tables = list(),
  audit = NULL,
  format = c("report", "dashboard"),
  width = 8,
  height = 5,
  overwrite = FALSE
)
```

## Arguments

- data:

  Data frame describing the selected analysis records.

- file:

  Output HTML path. Existing files are protected by default.

- title, question, methods, finding, limitations, source, unit,
  denominator:

  Author-supplied report text. Missing text is displayed as "Not
  provided".

- plot:

  Optional ggplot figure.

- tables:

  Named list of data frames to include before the data profile.

- audit:

  Optional data frame of preparation/selection steps.

- format:

  Report or dashboard layout.

- width, height:

  Figure dimensions in inches.

- overwrite:

  Explicitly allow replacing an existing output file.

## Value

The output path, invisibly.

## Examples

``` r
f <- tempfile(fileext = ".html")
cata_report(data.frame(value = 1:3), f, title = "Teaching example")
```
