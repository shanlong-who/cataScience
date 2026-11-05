% Website translation.
\name{cata_plot}
\alias{cata_plot}
\title{使用明确变量名创建图表}
\usage{
cata_plot(data, type = "bar", x, y = NULL, group = NULL, facet = NULL,
  value = NULL, yend = NULL, lower = NULL, upper = NULL, title = NULL,
  subtitle = NULL, caption = NULL, xlab = NULL, ylab = NULL, sort = FALSE,
  percent = FALSE, bins = 10, style = "cata", log_scale = FALSE, reference = 1)
}
\arguments{
\item{data}{数据框。}
\item{type}{图表类型：bar（柱状图）、histogram（直方图）、density（密度图）、line（折线图）、scatter（散点图）、box（箱线图）、dot（点图）、heatmap（热图）、dumbbell（哑铃图）、forest（森林图）或 cascade（级联图）。}
\item{x, y}{坐标轴变量名。只有计数柱状图、直方图或密度图可以省略 \code{y}。森林图的 x 包含条目标签。}
\item{group, facet}{可选的分组和分面变量名。}
\item{value}{热图填色使用的数值变量。}
\item{yend}{哑铃图的第二个数值。}
\item{lower, upper}{森林图置信下限和上限的数值列。}
\item{title, subtitle, caption}{图表文字。}
\item{xlab, ylab}{可选的轴标签，适当时应注明单位。}
\item{sort}{按数值对单系列柱状图、点图或哑铃图排序。}
\item{percent}{数值是否为 0 到 100 范围的百分比。}
\item{bins}{直方图的组数。}
\item{style}{内置 \code{"cata"} 或可选 \code{"dsi"} 主题。}
\item{log_scale}{森林图的估计值轴是否使用对数尺度。}
\item{reference}{森林图参考值，比值比通常使用 1。}
}
\value{可编辑的 ggplot 对象，带有 \code{cata_rows} 属性，说明输入、绘图和省略的行数。}
\description{当 \code{y} 为 NULL 时，柱状图统计记录数；指定 \code{y} 时使用已汇总的值，并要求图表键唯一。折线图也要求每个 x/分组/分面组合只有一个值。图表省略所需测量值缺失的记录，并在图注中报告数量；比较图中的缺失类别会明确标注。}
\examples{
d <- data.frame(district = c("A", "B"), percent = c(75, 68))
cata_plot(d, "dot", "district", "percent", percent = TRUE)
}
