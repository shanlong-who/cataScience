# 启动 cataScience 扩展培训版

在经典培训应用上增加引导式工作流、公共卫生案例、带审计记录的数据准备、更多图表、多重插补教学，以及报告和
dashboard 导出。本地版核心活动可离线运行。

## Usage

``` r
run_catas(..., language = c("auto", "en", "zh"))
```

## Arguments

- ...:

  传给 [`shiny::runApp()`](https://rdrr.io/pkg/shiny/man/runApp.html)
  的参数。

- language:

  `"zh"` 为简体中文，`"en"` 为英文。默认的 `"auto"`
  优先采用保存的选择，再依据浏览器语言。可在顶部菜单切换。

## Value

调用的作用是启动应用；应用运行期间会占用 R 会话。

## See also

[`run_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/run_cata.md)

## Examples

``` r
if (interactive()) run_catas()
```
