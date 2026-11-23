# cataScience

**数据科学之旅（A Journey of Data
Science）**：面向数据初学者的交互式培训应用，从导入、清理、可视化走向分析与结果沟通。AI
可以协助工作，判断和责任仍由使用者承担。

cataScience 最初服务于 WHO 数据培训，包括 Global Health Learning Center
和国家办公室培训。课程内容也适合一般的数据科学入门、自学，以及在工作中开始使用
AI 助手的人。

[打开猫咖课堂](https://shanlong-who.github.io/cata/?lang=zh)

在线版使用 Shinylive，在浏览器中运行 R，无需安装
R。首次访问需要下载运行环境和所需 R
包，启动页会显示进度。网络较慢时请提前加载；本地 R
版适合需要离线使用的培训。在线版不提供 VIM 的 kNN 插补，本地版可安装 VIM
后启用。

上面的在线链接直接打开中文课堂。培训中可以随时点击应用顶部的 **English**
或 **中文** 切换语言，已加载的数据和练习进度都会保留。本站顶部的
**English** 可切换到当前页面的英文文档。本地 GitHub 版也可用
`run_cata(language = "zh")` 直接进入中文界面。

## 使用指南

| 指南 | 内容 |
|----|----|
| [快速入门](https://shanlong-who.github.io/cataScience/zh/articles/cataScience.md) | 安装、启动、模块导航与示例数据 |
| [数据质量工作流](https://shanlong-who.github.io/cataScience/zh/articles/data-quality-workflow.md) | 比较清理方法，检查文本和关联键，解释图表 |

## 安装

从 CRAN 安装正式版：

``` r

install.packages("cataScience")
```

如需 GitHub 上的当前版本：

``` r

# install.packages("remotes")
remotes::install_github("shanlong-who/cataScience")
```

## 启动应用

在 RStudio 控制台中运行课堂：

``` r

library(cataScience)
run_cata()
```

在“导入”页载入两份原始猫表。在“数据清理 → 合并 →
方法”用独立的两张小表比较四种连接。

## 可复用函数

无需启动 Shiny，也可以在 R 中使用这些函数：

``` r

library(cataScience)

measurements <- cata_example("cats")
personalities <- cata_example("cats2")
cata_missing(measurements)
cata_check_keys(measurements, "id")
joined <- cata_join(measurements, personalities, by = "id")
joined$audit
```

其他工具包括
[`cata_read()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_read.md)、[`cata_flag_outliers()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_flag_outliers.md)、[`cata_proportion()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_proportion.md)、[`cata_count_status()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_count_status.md)、[`cata_mice_demo()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_mice_demo.md)、[`theme_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/theme_cata.md)
和
[`cata_export()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_export.md)。在[函数参考](https://shanlong-who.github.io/cataScience/zh/reference/index.md)查看中文参数说明和示例，或用
`?function_name` 查看包内英文帮助。标记可疑值不会自动删除或替换数据。

## 依赖包

- **mice**：保留完整数据时的猫咪彩蛋。缺失数据的选读示例还演示预测均值匹配、完成数据集、迭代链诊断及模型估计合并。
- **VIM**：可选，仅用于原有的 kNN 插补。本地运行
  `install.packages("VIM")` 后可启用。缺失模式图使用
  [`mice::md.pattern()`](https://amices.org/mice/reference/md.pattern.html)。
- **rio**：已移除。Excel 文件使用 readxl，CSV 使用 readr。
- **naniar、skimr**：保留，用于课堂的缺失值演示和简洁的数据概况。
- **DSIR**：可选。安装后可以使用 `style = "dsi"`；应用也提供内置主题。

本地包安装完成后，内置课程和数据练习可离线运行。需要与外部 AI
助手互动的演示仍需网络。

## 课堂模块

| 模块       | 内容                                                      |
|------------|-----------------------------------------------------------|
| Import     | 上传 Excel/CSV，或使用内置示例                            |
| Cleaning   | 缺失数据、异常值、文本处理及数据关联                      |
| Visualize  | 七类图表、类别排序、两组猫数据对照图，以及单页 HTML 报告  |
| Statistics | 数据描述、正态分布、t 检验和回归                          |
| AI         | 提示词层次、四个 AI 练习、AI 辅助分析、错误案例及安全使用 |
| Quiz       | 27 道题，可按当前会话所学主题筛选                         |

第一次使用可从 **Import → Or use the example data**
开始，再依次进入缺失数据、异常值、可视化和测验。使用 **Reset to original
data** 比较不同清理方法。

应用运行时会占用 R 会话。使用 RStudio 的 Stop 按钮或在控制台按 Escape
停止。

## 开发与联系

可复用函数位于 `R/`，Shiny 模块和教学材料位于
`inst/app/`。在源代码目录中运行
[`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)，再运行
[`run_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/run_cata.md)
预览修改。发布前运行 `devtools::test()` 和 `devtools::check()`。

维护者：Shanlong Ding — <dings@who.int>。
