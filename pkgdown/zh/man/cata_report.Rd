% Website translation.
\name{cata_report}
\alias{cata_report}
\title{生成独立的报告或 dashboard}
\usage{
cata_report(data, file, title = "Data analysis report", question = "",
  methods = "", finding = "", limitations = "", source = "", unit = "",
  denominator = "", plot = NULL, tables = list(), audit = NULL,
  format = c("report", "dashboard"), width = 8, height = 5, overwrite = FALSE)
}
\arguments{
\item{data}{包含选定分析记录的数据框。}
\item{file}{输出 HTML 路径，默认保护已有文件。}
\item{title, question, methods, finding, limitations, source, unit, denominator}{作者提供的报告文字。未填写的内容显示为 "Not provided"。}
\item{plot}{可选的 ggplot 图表。}
\item{tables}{数据框的命名列表，放在数据概况之前。}
\item{audit}{可选的数据准备或筛选步骤表。}
\item{format}{报告或 dashboard 布局。}
\item{width, height}{图表尺寸，单位为英寸。}
\item{overwrite}{明确允许覆盖已有输出文件。}
}
\value{不可见地返回输出路径。}
\description{创建不依赖在线资源的本地 HTML 文件。文字会进行转义；发现与局限性由作者提供。dashboard 支持本地表格搜索。如需可编辑且可复现的源文件，使用 \code{\link[=cata_export]{cata_export()}}。}
\examples{
f <- tempfile(fileext = ".html")
cata_report(data.frame(value = 1:3), f, title = "Teaching example")
}
