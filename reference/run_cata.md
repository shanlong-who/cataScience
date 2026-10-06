# Launch the "A Journey of Data Science" training app

Starts the interactive training app bundled with the package: import,
clean, visualize, and understand data, then learn to work with AI
assistants safely. The app opens in your default browser.

## Usage

``` r
run_cata(...)
```

## Arguments

- ...:

  Passed on to
  [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html), for
  example `port` or `launch.browser`.

## Value

No return value; called for the side effect of launching the app. The
function blocks the R session while the app is running.

## Examples

``` r
# The app is bundled with the package and launched from its own directory.
app_dir <- system.file("app", package = "cataScience")
file.exists(file.path(app_dir, "app.R"))
#> [1] TRUE

# Starting the app needs an interactive session, since it blocks R until
# the browser window is closed.
if (interactive()) {
  run_cata()
}
```
