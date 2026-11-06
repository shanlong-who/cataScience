# cataScience

**数据科学之旅（A Journey of Data
Science）**：面向数据初学者的交互式培训应用，从导入、清理、可视化走向分析与结果沟通。AI
可以协助工作，判断和责任仍由使用者承担。

cataScience 最初服务于 WHO 数据培训，包括 Global Health Learning Center
和国家办公室培训。课程内容也适合一般的数据科学入门、自学，以及在工作中开始使用
AI 助手的人。

**在线体验：[扩展培训版](https://shanlong-who.github.io/cata/?lang=zh) ·
[经典版](https://shanlong-who.github.io/cata/classic/?lang=zh)**

在线版使用 Shinylive，在浏览器中运行 R，无需安装
R。首次访问需要下载运行环境和所需 R
包，启动页会显示进度。网络较慢时请提前加载；本地 R
版适合需要离线使用的培训。在线版不提供 VIM 的 kNN 插补，本地版可安装 VIM
后启用。

上面的在线链接直接打开中文课堂。培训中可以随时点击应用顶部的 **English**
或 **中文** 切换语言，已加载的数据和练习进度都会保留。本站顶部的
**English** 可切换到当前页面的英文文档。本地 GitHub 版也可用
`run_cata(language = "zh")` 或 `run_catas(language = "zh")`
直接进入中文界面。

## 使用指南

| 指南 | 内容 |
|----|----|
| [快速入门](https://shanlong-who.github.io/cataScience/zh/articles/cataScience.md) | 安装、启动、模块导航与示例数据 |
| [数据质量工作流](https://shanlong-who.github.io/cataScience/zh/articles/data-quality-workflow.md) | 比较清理方法，检查文本和关联键，解释图表 |
| [培训指南](https://shanlong-who.github.io/cataScience/zh/articles/training-guide.md) | 安排三小时数据科学培训或两小时 AI 培训 |

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

在 RStudio 控制台中运行经典版：

``` r

library(cataScience)
run_cata()
```

2.2 版新增扩展培训入口：

``` r

run_catas()
```

扩展版从 **Why data matters（数据为什么重要）** 开始，通过 **Workflow**
串联数据理解、问题检查、关联和汇总、可视化及结果沟通。操作保留输入快照和整理记录，支持撤销与重置。

数据集 A 为虚构的服务级联数据，B/C
为合成的抗反转录病毒治疗（ART）记录和机构表，用于老挝培训。这些是教学数据，不是国家估计；A
与 B/C 相互独立。

课程还包括 John Snow
的地图、明确分子与分母、多重插补猫咪示例，以及卡方检验和逻辑回归示例。AI
图表比较仍作为独立课堂练习，使用相同的导出合成数据。

## 可视化与结果沟通

**Workflow → Visualise** 提供 11
类图表：柱状图、排序点图、直方图、密度图、折线图、散点图、箱线图、热图、哑铃图、森林图和级联图。可以修改标题、单位、分组和分面，查看被省略的缺失记录数，并按指定尺寸导出
PNG/PDF。

**Workflow → Communicate** 可生成独立的 HTML 报告或
dashboard，生成后的文件无需联网即可打开。使用者填写问题、发现、分母和局限性，应用不会代替使用者编造结论。

项目 ZIP 包括输入和选定数据、经过检查的整理代码、图表设置、HTML、Quarto
源文件、RStudio 项目，以及本地 Shiny dashboard。在 RStudio
中打开项目后，运行 `source("analysis.R")`
可重新生成分析。只有重新渲染可编辑的 `.qmd` 文件才需要 Quarto。ZIP
同时包含原始输入和选定记录，分享前应检查其中的数据。

## 可复用函数

无需启动 Shiny，也可以在 R 中使用这些函数：

``` r

library(cataScience)

patients <- cata_example("art")
facilities <- cata_example("facilities")
cata_profile(patients)
cata_missing(patients)
cata_check_keys(patients, "patient_id")

joined <- cata_join(patients, facilities, by = "facility_id")
joined$audit

lesson <- cata_lao_analysis()
lesson$flow
summary <- lesson$summary
figure <- cata_plot(summary, "dot", "group", "percent",
  percent = TRUE, sort = TRUE,
  title = "Reported viral-load testing by facility type",
  ylab = "Tested among records with known status (%)")
figure

# Choose a new output file; existing files are protected.
cata_report(lesson$selected, "training-report.html", plot = figure,
  tables = list("Reported testing" = summary),
  source = "Synthetic Lao workshop B/C example",
  unit = "Selected annual ART record",
  denominator = "Records with known reported VL testing status in each group",
  limitations = "Synthetic data; unresolved source and selection issues remain.")
```

其他工具包括
[`cata_read()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_read.md)、[`cata_flag_outliers()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_flag_outliers.md)、[`cata_proportion()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_proportion.md)、[`cata_count_status()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_count_status.md)、[`cata_mice_demo()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_mice_demo.md)、[`theme_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/theme_cata.md)
和
[`cata_export()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_export.md)。在[函数参考](https://shanlong-who.github.io/cataScience/zh/reference/index.md)查看中文参数说明和示例，或用
`?function_name` 查看包内英文帮助。标记可疑值不会自动删除或替换数据。

## 依赖包

- **mice**：保留完整数据时的猫咪彩蛋。扩展课程还演示预测均值匹配、完成数据集、迭代链诊断及模型估计合并。
- **VIM**：可选，仅用于原有的 kNN 插补。本地运行
  `install.packages("VIM")` 后可启用。缺失模式图使用
  [`mice::md.pattern()`](https://amices.org/mice/reference/md.pattern.html)。
- **rio**：已移除。Excel 文件使用 readxl，CSV 使用 readr。
- **naniar、skimr**：保留，用于经典版的缺失值演示和简洁的数据概况。
- **DSIR**：可选。安装后可以使用 `style = "dsi"` 或在图表构建器中选择
  DSIR 主题；应用也提供内置主题。

本地包安装完成后，内置课程和数据练习可离线运行。需要与外部 AI
助手互动的演示仍需网络。

## 经典版模块

| 模块       | 内容                                                  |
|------------|-------------------------------------------------------|
| Import     | 上传 Excel/CSV，或使用内置示例                        |
| Cleaning   | 缺失数据、异常值、文本处理及数据关联                  |
| Visualize  | 7 类图表，支持分组、分面和坐标翻转                    |
| Statistics | 数据描述、正态分布、t 检验和回归                      |
| AI         | 提示词层次、提示词库、AI 辅助分析、错误案例及安全使用 |
| Quiz       | 27 道题，可按当前会话所学主题筛选                     |
| Training   | 教师手册、实验脚本和分析审阅清单                      |

第一次使用可从 **Import → Or use the example data**
开始，再依次进入缺失数据、异常值、可视化和测验。使用 **Reset to original
data** 比较不同清理方法。

应用运行时会占用 R 会话。使用 RStudio 的 Stop 按钮或在控制台按 Escape
停止。

## 给培训者

应用中的 **Training → Training guide**
包含模块建议时长、三小时数据科学课程、两小时 AI
课程和全天课程安排，以及课前检查清单。

没有安装 R 的学员可使用在线版，或联系维护者获取另行提供的 Windows
便携版。出行前请测试两种启动入口、示例数据和导出功能。

## 开发与联系

可复用函数位于 `R/`，Shiny 模块和教学材料位于
`inst/app/`。在源代码目录中运行
[`pkgload::load_all()`](https://pkgload.r-lib.org/reference/load_all.html)，再运行
[`run_catas()`](https://shanlong-who.github.io/cataScience/zh/reference/run_catas.md)
预览修改。发布前运行 `devtools::test()` 和 `devtools::check()`。

维护者：Shanlong Ding — <dings@who.int>。
