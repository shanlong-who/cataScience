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

A tibble with a `cata_source` attribute, or the catalogue. Teaching
datasets A, B and C are synthetic. A is independent of B/C and must not
be linked to individual ART records.

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
