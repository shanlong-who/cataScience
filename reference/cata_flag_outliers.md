# Flag values for review without changing them

An IQR flag is a screening result, not evidence of an erroneous value.
Use explicit `limits` only when a documented rule supports them.

## Usage

``` r
cata_flag_outliers(x, k = 1.5, limits = NULL)
```

## Arguments

- x:

  A numeric vector.

- k:

  Non-negative multiplier for the IQR rule.

- limits:

  Optional numeric lower and upper limits (inclusive).

## Value

A tibble retaining every row and value, with bounds, a review flag, and
a reason. Missing values receive an unknown outlier flag.

## Examples

``` r
cata_flag_outliers(c(1:9, 100, NA))
#> # A tibble: 11 × 6
#>      row value lower upper flag  reason            
#>    <int> <dbl> <dbl> <dbl> <lgl> <chr>             
#>  1     1     1  -3.5  14.5 FALSE Within bounds     
#>  2     2     2  -3.5  14.5 FALSE Within bounds     
#>  3     3     3  -3.5  14.5 FALSE Within bounds     
#>  4     4     4  -3.5  14.5 FALSE Within bounds     
#>  5     5     5  -3.5  14.5 FALSE Within bounds     
#>  6     6     6  -3.5  14.5 FALSE Within bounds     
#>  7     7     7  -3.5  14.5 FALSE Within bounds     
#>  8     8     8  -3.5  14.5 FALSE Within bounds     
#>  9     9     9  -3.5  14.5 FALSE Within bounds     
#> 10    10   100  -3.5  14.5 TRUE  Outside IQR bounds
#> 11    11    NA  -3.5  14.5 NA    Missing           
```
