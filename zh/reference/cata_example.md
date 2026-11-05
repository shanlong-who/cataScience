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

带有 `cata_source` 属性的 tibble，或示例目录。教学数据 A、B、C
均为合成数据。A 与 B/C 独立，不应关联到个人 ART 记录。

## Examples

``` r
cata_example()
#> # A tibble: 7 × 4
#>   name          file                                        unit     description
#>   <chr>         <chr>                                       <chr>    <chr>      
#> 1 cats          app/data/cat-dirty-data.xlsx                Cat rec… Original t…
#> 2 cats2         app/data/cat-dirty-data2.xlsx               Cat rec… Second ori…
#> 3 cascade       training-data/Dataset_A_Student.xlsx        Distric… Dataset A:…
#> 4 art_raw       training-data/dataset_b_raw.csv             Intende… Dataset B:…
#> 5 art           training-data/dataset_b_clean_reference.csv Intende… Dataset B …
#> 6 facilities    training-data/dataset_c.csv                 Facility Dataset C:…
#> 7 source_review training-data/dataset_b_source_review.csv   Repeate… Synthetic …
cats <- cata_example("cats")
```
