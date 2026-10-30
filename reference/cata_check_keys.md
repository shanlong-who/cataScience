# Check a proposed record key

Check a proposed record key

## Usage

``` r
cata_check_keys(data, key)
```

## Arguments

- data:

  A data frame.

- key:

  Character vector of key column names.

## Value

A list with a one-row `summary`, per-row `flags`, and all `review_rows`.
Every member of a repeated-key or identical-row group is flagged.
Repeated IDs are not automatically deleted.

## Examples

``` r
cata_check_keys(data.frame(id = c("A", "A", NA), value = 1:3), "id")
#> $summary
#> # A tibble: 1 × 6
#>   records distinct_complete_keys missing_key_rows repeated_key_rows
#>     <int>                  <int>            <int>             <int>
#> 1       3                      1                1                 2
#> # ℹ 2 more variables: identical_row_members <int>, key_is_unique <lgl>
#> 
#> $flags
#> # A tibble: 3 × 4
#>     row missing_key repeated_key identical_row
#>   <int> <lgl>       <lgl>        <lgl>        
#> 1     1 FALSE       TRUE         FALSE        
#> 2     2 FALSE       TRUE         FALSE        
#> 3     3 TRUE        FALSE        FALSE        
#> 
#> $review_rows
#>     id value
#> 1    A     1
#> 2    A     2
#> 3 <NA>     3
#> 
```
