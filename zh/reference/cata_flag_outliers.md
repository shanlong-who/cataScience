# 标记待检查值，不改变原始数据

IQR 标记是筛查结果，不能证明数值错误。只有存在有依据的规则时，才应指定
`limits`。

## Usage

``` r
cata_flag_outliers(x, k = 1.5, limits = NULL)
```

## Arguments

- x:

  数值向量。

- k:

  IQR 规则的非负倍数。

- limits:

  可选的数值下限和上限，边界本身视为范围内。

## Value

保留每一行和每个原始值的
tibble，同时给出边界、检查标记和原因。缺失值的异常标记为未知。

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
