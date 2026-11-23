# 关联数据表并返回审计记录

关联数据表，同时记录行数变化、键检查和未匹配记录。

## Usage

``` r
cata_join(x, y, by, type = c("left", "inner", "full", "right"),
  relationship = "many-to-one", na_matches = "never", suffix = c(".x", ".y"))
```

## Arguments

- x, y:

  数据框。

- by:

  字符形式的关联键；两表列名不同时，可以用命名向量指定对应关系。

- type:

  关联类型。

- relationship:

  预期的键关系，由 dplyr 检查。

- na_matches:

  缺失键是否可以匹配，默认为 `"never"`。

- suffix:

  两表中同名非键列的后缀。

## Value

列表，包含
`data`、`audit`、两表的键检查结果及未匹配输入行。输入表不被修改。

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
