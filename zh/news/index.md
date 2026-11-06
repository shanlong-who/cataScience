# Changelog

## cataScience 2.2.0

CRAN release: 2026-11-05

- 根据维护者的两只猫制作共享的导航栏图标与
  favicon，两种应用入口使用更醒目的圆形图标。网站保留原来的六角标志。
- 新增扩展培训入口
  [`run_catas()`](https://shanlong-who.github.io/cataScience/zh/reference/run_catas.md)，保留原入口
  [`run_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/run_cata.md)。工作流连接数据检查、带审计记录的关联、明确分母、图表及结果沟通，支持输入快照和撤销。
- 新增数据导入、概况、缺失值、键检查、异常值标记、关联、比例计算和状态汇总函数，并提供文档和示例。
- 新增支持 11 类图表的
  [`cata_plot()`](https://shanlong-who.github.io/cataScience/zh/reference/cata_plot.md)、[`theme_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/theme_cata.md)，以及可离线打开的
  HTML 报告和 dashboard。项目导出包括可复现的 R、Quarto 和 Shiny
  源文件、输入快照和整理记录。
- 新增“数据为什么重要”、John Snow 地图、服务级联，以及老挝培训合成数据
  B/C 的分析示例。AI 图表比较保留为应用外的课堂练习。
- 保留 mice
  猫咪彩蛋，增加基于合成猫咪数据的多重插补、诊断链及模型估计合并。
- 移除 rio；VIM 改为 kNN 的可选依赖，缺失模式图改用 mice；保留
  naniar、skimr 和可选 DSIR 主题。
- 修复经典版删除异常值时误删以 `shadow_`
  开头的原始列的问题，嵌套应用脚本明确按 UTF-8 加载。
- 修订测验解释，区分“需要检查的标记”与“错误”，以及缺失机制假设与实际观测数据能够支持的结论。

## cataScience 2.1.4

CRAN release: 2026-10-06

- 新增三篇指南：安装与启动、可复现的数据质量工作流，以及培训组织。
- 新增 pkgdown 文档网站，提供函数参考、可搜索的文章，并在包元数据和
  README 中添加链接。
- 根据维护者的两只猫设计六角标志，用于 README、网站和指南。

## cataScience 2.1.3

CRAN release: 2026-08-28

- Markdown
  课程改为从文本渲染，而不是直接传入文件路径。[`markdown::mark()`](https://rdrr.io/pkg/markdown/man/mark.html)
  2.0 及以上版本在 `R CMD check` 时会原地改写输入文件，这使 CRAN Debian
  环境的只读包库检查失败，也不符合只能写入会话临时目录的要求。改为文本渲染后不再写入文件，生成的
  HTML 保持一致。

## cataScience 2.1.2

CRAN release: 2026-07-30

- 新增 testthat
  测试，覆盖数据清理、文件导入、测验和清理模块服务器、题库及完整应用界面构建。
- [`run_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/run_cata.md)
  的示例现在也可在非交互会话中运行。
- 数据仍有缺失值时，异常值箱线图不再产生缺失值警告。

## cataScience 2.1.1

- Markdown
  课程中的图片随卡片宽度缩放，避免可视化、清理和导入模块的图片被裁切。
- 应用样式表链接增加版本参数，便于浏览器更新缓存样式。
- 将一张宽度为 9000 像素的内置图片缩小至 1800 像素。

## cataScience 2.1.0

- 首次发布：[`run_cata()`](https://shanlong-who.github.io/cataScience/zh/reference/run_cata.md)
  启动内置的“A Journey of Data Science”培训应用。
