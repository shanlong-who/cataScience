# 汇总报告的二元状态，并保留未知情况

汇总报告的二元状态，同时明确显示未知和空白记录。

## Usage

``` r
cata_count_status(data, status, yes = "Yes", no = "No", by = NULL)
```

## Arguments

- data:

  数据框。

- status:

  状态列名称。

- yes, no:

  表示成功和失败的不同字符标签。

- by:

  可选的分组列名称。

## Value

tibble，包含总记录数、yes、no、unknown、blank、已知状态分母及百分比。未知和空白状态不计入分母，并分别报告。所衡量的是报告状态，而不是经核实的服务或结果可获得性。

## Examples

``` r
cata_count_status(data.frame(test = c("Yes", "No", "Unknown", NA)), "test")
#> # A tibble: 1 × 8
#>   group       records   yes    no unknown blank known percent
#>   <chr>         <int> <int> <int>   <int> <int> <int>   <dbl>
#> 1 All records       4     1     1       1     1     2      50
```
