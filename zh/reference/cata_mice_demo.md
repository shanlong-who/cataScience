# 用合成猫咪数据学习多重插补

固定的教学模拟，设置体重缺失。在各个完成数据集上拟合同一个线性模型，再合并模型估计，而不是合并数据集。此函数不对上传记录进行插补；诊断图不能证明真实研究中的缺失机制假设成立。

## Usage

``` r
cata_mice_demo(m = 5, maxit = 5, seed = 2026)
```

## Arguments

- m:

  插补次数，范围 2 到 20。

- maxit:

  迭代次数，范围 2 到 20。

- seed:

  用于复现的整数随机种子。函数退出时恢复调用者原来的随机数状态。

## Value

列表，包含完整和有缺失的合成数据、`mids`
对象、完成数据集、合并模型估计，以及完整数据、完整案例、均值插补和多重插补合并斜率的比较。

## Examples

``` r
# \donttest{
demo <- cata_mice_demo(m = 3, maxit = 3)
demo$comparison
#> # A tibble: 4 × 5
#>   method                       estimate  lower  upper records
#>   <chr>                           <dbl>  <dbl>  <dbl>   <int>
#> 1 Complete synthetic data        0.108  0.0971 0.119      120
#> 2 Complete cases                 0.104  0.0912 0.116       84
#> 3 Single mean imputation         0.0750 0.0629 0.0872     120
#> 4 Multiple imputation (pooled)   0.102  0.0853 0.118      120
# }
```
