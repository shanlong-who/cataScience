# 汇总数据表的结构与质量

在开始分析前检查数据结构与基本质量。

## Usage

``` r
cata_profile(data)
```

## Arguments

- data:

  数据框。

## Value

每个变量一行，包含存储类型、记录数、已观测不同值数量、缺失情况及数值汇总。不修改任何值。

## Examples

``` r
cata_profile(data.frame(id = c("001", "002"), value = c(3, NA)))
#> # A tibble: 2 × 11
#>   variable type  records observed missing missing_pct distinct nonfinite minimum
#>   <chr>    <chr>   <int>    <int>   <int>       <dbl>    <int>     <int>   <dbl>
#> 1 id       char…       2        2       0           0        2         0      NA
#> 2 value    nume…       2        1       1          50        1         0       3
#> # ℹ 2 more variables: median <dbl>, maximum <dbl>
```
