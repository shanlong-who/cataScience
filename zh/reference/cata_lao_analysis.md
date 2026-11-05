# 复现老挝培训的合成数据分析

使用内置 B/C
参考文件及课程声明的筛选规则。这是完整教学示例，不是国家估计，也不是通用临床分析函数。报告已检测与检测结果可获得性、病毒抑制是不同概念。

## Usage

``` r
cata_lao_analysis()
```

## Value

列表，包含关联和筛选后的记录、关联审计、状态汇总、分析流程、卡方检验、逻辑回归模型及比值比表。常规模型区间未考虑机构内相关性。

## Examples

``` r
lesson <- cata_lao_analysis()
lesson$flow
#> # A tibble: 6 × 2
#>   stage                     records
#>   <chr>                       <int>
#> 1 Imported B records            604
#> 2 After many-to-one join        604
#> 3 After review policy           587
#> 4 Known Female/Male             582
#> 5 Known Yes/No                  577
#> 6 Complete model predictors     575
```
