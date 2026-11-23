# cataScience 快速入门

``` r

library(cataScience)
```

![以两只猫为原型的 cataScience 六角标志](assets/logo.png)

**cataScience** 启动 **A Journey of Data
Science**，帮助初学者学习导入、清理、可视化和理解数据。AI
课程帮助你描述任务、检查助手的工作，并对结果承担责任。

主要练习通过按钮、表格和图表完成，无需编写 R 代码。指南中的 R
示例用于展示如何在应用外复现相关分析。

## 选择在线版或本地版

无需安装
R，可直接打开中文版的[猫咖课堂](https://shanlong-who.github.io/cata/?lang=zh)。首次访问会下载运行环境和
R 包，请保持页面打开并查看进度。进入课堂后，点击顶部的 **English** 或
**中文** 即可切换语言。

如需稳定的离线课堂环境，可在 RStudio
中使用本地包。安装完成后，内置课程和数据练习无需联网；与外部 AI
助手互动的演示仍需网络和相应账户。

## 安装与启动

从 CRAN 安装正式版：

``` r

install.packages("cataScience")
```

或安装 GitHub 当前版本：

``` r

install.packages("remotes")
remotes::install_github("shanlong-who/cataScience")
```

在 RStudio 控制台中启动课堂：

``` r

library(cataScience)
run_cata()
```

应用会在浏览器中打开，但实际运行于本地 R 会话。应用运行时 R
控制台保持忙碌；使用 RStudio 的 Stop 按钮或在控制台按 Escape
停止。仅关闭浏览器标签页可能不会终止 R 会话。

也可以手动指定端口：

``` r

run_cata(launch.browser = FALSE, port = 3838)
```

随后自行打开 `http://127.0.0.1:3838`。如果端口被占用，请换一个端口。

## 第一次学习

1.  在 **Home** 阅读数据科学工作流。
2.  打开 **Import**，在 Dataset 1 中点击 **Or use the example data**。
3.  检查数据预览：行、列、变量类型和缺失值。
4.  打开 **Cleaning → Missing
    data**，先比较两种方法，再应用修改；明确选择要修改的变量。
5.  打开 **Cleaning → Outliers**，讨论被标记的值是错误还是有效观测。
6.  打开 **Visualize**，选择能回答一个明确问题的图表。
7.  打开 **Quiz**，选择本次所学主题，点击 **Apply topics and restart**。

比较清理方法时，使用 **Reset to original data**
恢复导入的数据。同一会话中的清理结果会进入后续活动。重新加载或重新启动应用会开始新会话，请保留原始练习文件。

继续阅读[数据质量工作流](https://shanlong-who.github.io/cataScience/zh/articles/data-quality-workflow.md)，完成包含讨论问题和可复现
R 示例的练习。

## 模块导航

| 模块 | 练习内容 |
|----|----|
| Import | 加载一到两个 Excel/CSV 文件或示例数据，检查预览 |
| Cleaning → Missing data | 删除行、向上或向下填充、均值或中位数替换；本地版可选 kNN |
| Cleaning → Outliers | IQR 规则、删除异常值与缩尾处理 |
| Cleaning → Text | 选择字符变量并统一大小写 |
| Cleaning → Merge | 选择关联键，进行左、右、内或全关联 |
| Visualize | 七类图表、类别排序、两组猫数据对照图，以及单页 HTML 报告 |
| Statistics | 数据描述、正态分布、t 检验和回归 |
| AI | 提示词层次、四个 AI 练习、辅助分析、方法错误案例及安全使用 |
| Quiz | 主题筛选、答案解释和最终练习 |

**Background**、**Type**、**Methodology** 和 **Principles**
标签提供实践背后的简短解释。

## 使用自己的文件

Import 接受 `.csv`、`.xlsx` 和 `.xls`。初次 Excel
练习建议使用单工作表文件：第一行为变量名，每列一个变量，每行一个观测。避免在数据区域放置备注、合并单元格和汇总行。

多数活动只需上传一个文件；练习关联时再上传第二个文件，并先检查关联键。

课堂 Home 的 **Download datasets** 可获取练习文件。也可以在 R
中找到主教学工作簿：

``` r

example.file <- system.file(
  "app", "data", "cat-dirty-data.xlsx", package = "cataScience"
)
file.exists(example.file)
#> [1] TRUE
```

载入两张猫表。在 **数据清理 → 异常值 → 数据集 1 →
核对并更正原始记录**，对照猫咖记录检查 Trevor 的身长和 Stanley
的体重，输入核实值并填写依据。缺失值页也有同样的操作，可补上查证的实测值。可以随时查看本次导入的原表和手动更正记录。

按 `id` 合并并应用后，在 **可视化 → 对照看图**
比较只数与组内百分比，或比较组均值与每只猫的体重。回到清理页再修改，已应用的合并和图也会更新。展开图下方的
**写下发现并导出报告**，写一条发现和一条局限，即可下载可离线阅读的 HTML
页面。

## 使用 AI 课程

先阅读 **AI → 提示词层次**，再选一个 **四个 AI 练习**
中的任务。向助手提供明确任务、相关背景、预期输出和检查标准。

**AI-assisted analysis** 用于审阅数据与结论；**When AI gets it wrong**
展示为什么必须回到来源核对当前指标方法。应用只展示教学材料，不调用 AI
服务，也不会把上传的数据发送给 AI 助手。

## 常见问题

| 问题 | 回答 |
|----|----|
| 学员需要安装 R 吗？ | 在线版不需要；本地包需要 R。维护者还可另行提供 Windows 便携版 |
| 可以离线使用吗？ | 本地版的内置课程与数据活动可以；外部 AI 演示需要联网 |
| 在线页面一直等待怎么办？ | 查看启动进度和错误详情，检查网络后重试；网络受限时使用本地版 |
| 为什么数据预览为空？ | 先在 Import 上传文件或点击示例数据按钮 |
| 如何撤销清理？ | 课堂使用 Reset to original data |
| 为什么测验重新开始了？ | 应用新的主题筛选会重置本次会话的题目和分数 |
| 为什么没有 kNN？ | 在线版不提供；本地版需要另行安装 VIM |

``` r

packageVersion("cataScience")
#> [1] '3.0.0'
```

如遇问题，请在 [cataScience issue
tracker](https://github.com/shanlong-who/cataScience/issues)
说明包版本、所在页面和错误信息。
