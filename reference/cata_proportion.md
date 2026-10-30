# Calculate proportions with explicit denominators

Calculate proportions with explicit denominators

## Usage

``` r
cata_proportion(numerator, denominator, scale = 100)
```

## Arguments

- numerator, denominator:

  Numeric counts of equal length, or one scalar.

- scale:

  Multiplier, usually 100 for percentages.

## Value

A tibble with the input counts, `value`, and `status`. Invalid counts
and zero denominators produce NA, with the reason retained.

## Examples

``` r
cata_proportion(c(200, 233, 0), c(265, 315, 0))
#> # A tibble: 3 × 4
#>   numerator denominator value status          
#>       <dbl>       <dbl> <dbl> <chr>           
#> 1       200         265  75.5 OK              
#> 2       233         315  74.0 OK              
#> 3         0           0  NA   Zero denominator
```
