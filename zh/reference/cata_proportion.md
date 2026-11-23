# 使用明确分母计算比例

明确保留分子和分母，并记录无法计算比例的原因。

## Usage

``` r
cata_proportion(numerator, denominator, scale = 100)
```

## Arguments

- numerator, denominator:

  数值计数，长度相同，或其中一个为单值。

- scale:

  乘数，计算百分比时通常为 100。

## Value

tibble，包含输入计数、`value` 和 `status`。无效计数或零分母得到
NA，并保留原因。

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
