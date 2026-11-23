# 检查候选记录键

检查候选记录键，帮助区分缺失键、重复键和完全重复的行。

## Usage

``` r
cata_check_keys(data, key)
```

## Arguments

- data:

  数据框。

- key:

  键列名称组成的字符向量。

## Value

列表，包含一行汇总 `summary`、逐行标记 `flags` 和所有待检查行
`review_rows`。重复键组或完全相同行组中的每个成员都会被标记；不会自动删除重复
ID。

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
