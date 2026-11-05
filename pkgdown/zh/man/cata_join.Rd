% Website translation.
\name{cata_join}
\alias{cata_join}
\title{关联数据表并返回审计记录}
\usage{
cata_join(x, y, by, type = c("left", "inner", "full", "right"),
  relationship = "many-to-one", na_matches = "never", suffix = c(".x", ".y"))
}
\arguments{
\item{x, y}{数据框。}
\item{by}{字符形式的关联键；两表列名不同时，可以用命名向量指定对应关系。}
\item{type}{关联类型。}
\item{relationship}{预期的键关系，由 dplyr 检查。}
\item{na_matches}{缺失键是否可以匹配，默认为 \code{"never"}。}
\item{suffix}{两表中同名非键列的后缀。}
}
\value{列表，包含 \code{data}、\code{audit}、两表的键检查结果及未匹配输入行。输入表不被修改。}
\description{关联数据表，同时记录行数变化、键检查和未匹配记录。}
\examples{
cata_join(data.frame(id = c(1, 2, NA)), data.frame(id = 1:2, label = c("A", "B")), by = "id")
}
