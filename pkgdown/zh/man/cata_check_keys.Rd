% Website translation; function signatures and examples match the package help.
\name{cata_check_keys}
\alias{cata_check_keys}
\title{检查候选记录键}
\usage{cata_check_keys(data, key)}
\arguments{
\item{data}{数据框。}
\item{key}{键列名称组成的字符向量。}
}
\value{列表，包含一行汇总 \code{summary}、逐行标记 \code{flags} 和所有待检查行 \code{review_rows}。重复键组或完全相同行组中的每个成员都会被标记；不会自动删除重复 ID。}
\description{检查候选记录键，帮助区分缺失键、重复键和完全重复的行。}
\examples{cata_check_keys(data.frame(id = c("A", "A", NA), value = 1:3), "id")}
