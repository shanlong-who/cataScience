# 加载有文档说明的示例数据

加载包内示例及其来源信息。

## Usage

``` r
cata_example(name = NULL)
```

## Arguments

- name:

  示例名称。NULL 返回示例目录。

## Value

带有 `cata_source` 属性的 tibble，或示例目录。

## Examples

``` r
cata_example()
#> # A tibble: 2 × 4
#>   name  file                          unit       description                    
#>   <chr> <chr>                         <chr>      <chr>                          
#> 1 cats  app/data/cat-dirty-data.xlsx  Cat record Original teaching cats; sampli…
#> 2 cats2 app/data/cat-dirty-data2.xlsx Cat record Second original cat table for …
cats <- cata_example("cats")
```
