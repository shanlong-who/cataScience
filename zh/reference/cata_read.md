# 读取培训数据文件

读取 CSV 或
Excel，不修改源文件。如果标识符含前导零，应明确指定列类型；可用 `range`
排除 Excel 备注和页脚。

## Usage

``` r
cata_read(path, format = tools::file_ext(path), sheet = 1, range = NULL,
  col_types = NULL, na = c("", "NA"))
```

## Arguments

- path:

  现有文件的路径。

- format:

  扩展名：`csv`、`xls` 或
  `xlsx`。上传产生的临时文件不含原始扩展名时，可明确指定。

- sheet:

  Excel 工作表名称或序号。

- range:

  可选的 Excel 单元格范围。

- col_types:

  传给所选读取函数的列类型设置。

- na:

  应解释为缺失值的字符内容。

## Value

tibble。CSV 解析问题可用
[`readr::problems()`](https://readr.tidyverse.org/reference/problems.html)
查看。

## Examples

``` r
cats <- cata_example("cats")
cata_profile(cats)
#> # A tibble: 8 × 11
#>   variable type  records observed missing missing_pct distinct nonfinite minimum
#>   <chr>    <chr>   <int>    <int>   <int>       <dbl>    <int>     <int>   <dbl>
#> 1 id       char…      31       31       0        0          31         0    NA  
#> 2 name     char…      31       31       0        0          31         0    NA  
#> 3 gender   char…      31       31       0        0           4         0    NA  
#> 4 length_… nume…      31       31       0        0          31         0     5  
#> 5 height_… nume…      31       31       0        0          27         0    25.3
#> 6 weight_… nume…      31       28       3        9.68       21         0     1.8
#> 7 age_yea… nume…      31       31       0        0          12         0     1  
#> 8 neutered logi…      31       31       0        0           2         0    NA  
#> # ℹ 2 more variables: median <dbl>, maximum <dbl>
```
