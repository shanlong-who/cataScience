# Read a training dataset

Read a CSV or Excel table without modifying the source file. Specify
column types when identifiers contain leading zeroes. Excel notes and
footers can be excluded with `range`.

## Usage

``` r
cata_read(
  path,
  format = tools::file_ext(path),
  sheet = 1,
  range = NULL,
  col_types = NULL,
  na = c("", "NA")
)
```

## Arguments

- path:

  Path to an existing file.

- format:

  File extension (`csv`, `xls`, or `xlsx`). Useful for uploaded
  temporary files whose names do not contain the original extension.

- sheet:

  Excel sheet name or number.

- range:

  Optional Excel cell range.

- col_types:

  Column specification passed to the selected reader.

- na:

  Character values to interpret as missing.

## Value

A tibble. CSV parsing problems remain available through
[`readr::problems()`](https://readr.tidyverse.org/reference/problems.html).

## Examples

``` r
cats <- cata_example("cats")
cata_profile(cats)
#> # A tibble: 8 × 11
#>   variable type  records observed missing missing_pct distinct nonfinite minimum
#>   <chr>    <chr>   <int>    <int>   <int>       <dbl>    <int>     <int>   <dbl>
#> 1 id       char…      31       31       0        0          31         0    NA  
#> 2 name     char…      31       31       0        0          31         0    NA  
#> 3 gender   char…      31       31       0        0           4         0    NA  
#> 4 length_… nume…      31       31       0        0          31         0     5  
#> 5 height_… nume…      31       31       0        0          27         0    25.3
#> 6 weight_… nume…      31       28       3        9.68       21         0     1.8
#> 7 age_yea… nume…      31       31       0        0          12         0     1  
#> 8 neutered logi…      31       31       0        0           2         0    NA  
#> # ℹ 2 more variables: median <dbl>, maximum <dbl>
```
