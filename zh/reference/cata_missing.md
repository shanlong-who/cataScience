# 统计缺失值和缺失模式

按变量、记录或模式统计缺失情况。

## Usage

``` r
cata_missing(data, by = c("variable", "record", "pattern"))
```

## Arguments

- data:

  数据框。

- by:

  汇总层级：变量、记录或缺失模式。

## Value

tibble。模式按输入列的顺序编码，`1` 表示缺失，`0`
表示已观测；`variables` 属性记录列顺序。

## Examples

``` r
cata_missing(data.frame(a = c(1, NA), b = c(NA, NA)))
#> # A tibble: 2 × 4
#>   variable missing observed missing_pct
#>   <chr>      <dbl>    <dbl>       <dbl>
#> 1 a              1        1          50
#> 2 b              2        0         100
```
