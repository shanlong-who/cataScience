# 启动经典版“数据科学之旅”培训应用

启动包内的交互式培训应用，学习导入、清理、可视化和理解数据，以及安全地与
AI 助手协作。应用在默认浏览器中打开。

## Usage

``` r
run_cata(..., language = c("auto", "en", "zh"))
```

## Arguments

- ...:

  传给 [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html)
  的参数，例如 `port` 或 `launch.browser`。

- language:

  `"zh"` 为简体中文，`"en"` 为英文。默认的 `"auto"`
  优先采用保存的选择，再依据浏览器语言。可在顶部菜单切换。

## Value

无返回值，调用的作用是启动应用。应用运行期间会占用 R 会话。

## Examples

``` r
# The app is bundled with the package.
app_dir <- system.file("app", package = "cataScience")
file.exists(file.path(app_dir, "app.R"))
#> [1] TRUE
if (interactive()) run_cata()
```
