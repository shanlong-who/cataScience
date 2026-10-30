# Join tables and return an audit

Join tables and return an audit

## Usage

``` r
cata_join(
  x,
  y,
  by,
  type = c("left", "inner", "full", "right"),
  relationship = "many-to-one",
  na_matches = "never",
  suffix = c(".x", ".y")
)
```

## Arguments

- x, y:

  Data frames.

- by:

  Character join keys, optionally named to match different names.

- type:

  Join type.

- relationship:

  Expected key relationship; checked by dplyr.

- na_matches:

  Whether missing keys can match. Defaults to `"never"`.

- suffix:

  Suffixes for overlapping non-key columns.

## Value

A list containing `data`, `audit`, both key checks, and unmatched input
rows. Input tables are unchanged.

## Examples

``` r
cata_join(data.frame(id = c(1, 2, NA)), data.frame(id = 1:2, label = c("A", "B")), by = "id")
#> $data
#>   id label
#> 1  1     A
#> 2  2     B
#> 3 NA  <NA>
#> 
#> $audit
#> # A tibble: 1 × 7
#>   left_rows right_rows result_rows matched_left_rows unmatched_left_rows
#>       <int>      <int>       <int>             <int>               <int>
#> 1         3          2           3                 2                   1
#> # ℹ 2 more variables: unmatched_right_rows <int>, row_change <int>
#> 
#> $left_keys
#> $left_keys$summary
#> # A tibble: 1 × 6
#>   records distinct_complete_keys missing_key_rows repeated_key_rows
#>     <int>                  <int>            <int>             <int>
#> 1       3                      2                1                 0
#> # ℹ 2 more variables: identical_row_members <int>, key_is_unique <lgl>
#> 
#> $left_keys$flags
#> # A tibble: 3 × 4
#>     row missing_key repeated_key identical_row
#>   <int> <lgl>       <lgl>        <lgl>        
#> 1     1 FALSE       FALSE        FALSE        
#> 2     2 FALSE       FALSE        FALSE        
#> 3     3 TRUE        FALSE        FALSE        
#> 
#> $left_keys$review_rows
#>   id
#> 3 NA
#> 
#> 
#> $right_keys
#> $right_keys$summary
#> # A tibble: 1 × 6
#>   records distinct_complete_keys missing_key_rows repeated_key_rows
#>     <int>                  <int>            <int>             <int>
#> 1       2                      2                0                 0
#> # ℹ 2 more variables: identical_row_members <int>, key_is_unique <lgl>
#> 
#> $right_keys$flags
#> # A tibble: 2 × 4
#>     row missing_key repeated_key identical_row
#>   <int> <lgl>       <lgl>        <lgl>        
#> 1     1 FALSE       FALSE        FALSE        
#> 2     2 FALSE       FALSE        FALSE        
#> 
#> $right_keys$review_rows
#> [1] id    label
#> <0 rows> (or 0-length row.names)
#> 
#> 
#> $unmatched_left
#>   id
#> 1 NA
#> 
#> $unmatched_right
#> [1] id    label
#> <0 rows> (or 0-length row.names)
#> 
```
