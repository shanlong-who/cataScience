# Explore multiple imputation using synthetic cats

A fixed teaching simulation with missing weights. Fits the same linear
model to each completed dataset and pools model estimates, not datasets.
It does not impute uploaded records. Diagnostic plots do not establish
that the missingness assumptions hold in a real study.

## Usage

``` r
cata_mice_demo(m = 5, maxit = 5, seed = 2026)
```

## Arguments

- m:

  Number of imputations, from 2 to 20.

- maxit:

  Number of iterations, from 2 to 20.

- seed:

  Integer seed for reproducibility. The caller's random-number state is
  restored on exit.

## Value

A list with complete and incomplete synthetic data, the `mids` object,
completed datasets, pooled model estimates and a comparison of the
complete-data, complete-case, mean-imputed and pooled slopes.

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
