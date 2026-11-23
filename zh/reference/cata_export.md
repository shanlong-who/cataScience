# 导出可复现的结果沟通项目

生成新目录，包含输入与选定数据快照、R 脚本、报告和 dashboard
HTML、Quarto 源文件及本地 Shiny dashboard。R
脚本根据给定准备步骤重建选定数据，然后重新计算汇总与图表。输入 RDS
快照保留标识符、因子、日期和列类型。

## Usage

``` r
cata_export(data, directory, input = data, steps = character(),
  join_data = NULL, plot_args = NULL, summary_spec = NULL,
  chart_data = c("records", "summary"), audit = NULL,
  title = "Data analysis report", question = "", methods = "", finding = "",
  limitations = "", source = "", unit = "", denominator = "", width = 8, height = 5)
```

## Arguments

- data:

  选定的分析数据。

- directory:

  新的输出目录，已有目录受到保护。

- input:

  执行所列准备步骤之前的原始输入快照。

- steps:

  R 数据准备语句组成的字符向量，每条语句操作
  `analysis.data`。这些语句写入导出的脚本，不由本函数执行。只应导出已经检查过的语句。

- join_data:

  准备步骤所用的可选参考表快照。

- plot_args:

  传给
  [`cata_plot()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_plot.md)
  的命名参数，不含 data。

- summary_spec:

  传给
  [`cata_count_status()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_count_status.md)
  的可选参数，不含 data。项目运行时会重新计算状态汇总。

- chart_data:

  图表使用选定记录或状态汇总。

- audit:

  可选的准备过程记录。

- title, question, methods, finding, limitations, source, unit,
  denominator:

  作者提供的报告文字。

- width, height:

  图表尺寸，单位为英寸，保留在项目中。

## Value

不可见地返回新目录。即使未安装 Quarto 也会生成源文件；现成 HTML 不需要
Quarto 或服务器。

## Examples

``` r
# \donttest{
out <- tempfile("cata-project-")
cata_export(data.frame(value = 1:5), out, title = "Example report")
# }
```
