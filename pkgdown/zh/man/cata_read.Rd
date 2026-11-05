% Website translation.
\name{cata_read}
\alias{cata_read}
\title{读取培训数据文件}
\usage{
cata_read(path, format = tools::file_ext(path), sheet = 1, range = NULL,
  col_types = NULL, na = c("", "NA"))
}
\arguments{
\item{path}{现有文件的路径。}
\item{format}{扩展名：\code{csv}、\code{xls} 或 \code{xlsx}。上传产生的临时文件不含原始扩展名时，可明确指定。}
\item{sheet}{Excel 工作表名称或序号。}
\item{range}{可选的 Excel 单元格范围。}
\item{col_types}{传给所选读取函数的列类型设置。}
\item{na}{应解释为缺失值的字符内容。}
}
\value{tibble。CSV 解析问题可用 \code{\link[readr:problems]{readr::problems()}} 查看。}
\description{读取 CSV 或 Excel，不修改源文件。如果标识符含前导零，应明确指定列类型；可用 \code{range} 排除 Excel 备注和页脚。}
\examples{
cats <- cata_example("cats")
cata_profile(cats)
}
