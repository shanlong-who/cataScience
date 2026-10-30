# Summarise a reported binary status with unknowns kept visible

Summarise a reported binary status with unknowns kept visible

## Usage

``` r
cata_count_status(data, status, yes = "Yes", no = "No", by = NULL)
```

## Arguments

- data:

  A data frame.

- status:

  Status column name.

- yes, no:

  Distinct character labels for success and failure.

- by:

  Optional grouping column name.

## Value

A tibble with records, yes, no, unknown, blank, known denominator and
percent. Unknown/blank statuses are excluded from the denominator and
reported separately. The measure is reported status, not verified
service/result availability.

## Examples

``` r
cata_count_status(data.frame(test = c("Yes", "No", "Unknown", NA)), "test")
#> # A tibble: 1 × 8
#>   group       records   yes    no unknown blank known percent
#>   <chr>         <int> <int> <int>   <int> <int> <int>   <dbl>
#> 1 All records       4     1     1       1     1     2      50
```
