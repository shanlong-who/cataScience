# Load a documented example

Load a documented example

## Usage

``` r
cata_example(name = NULL)
```

## Arguments

- name:

  Example name. NULL returns the catalogue.

## Value

A tibble with a `cata_source` attribute, or the catalogue.

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
