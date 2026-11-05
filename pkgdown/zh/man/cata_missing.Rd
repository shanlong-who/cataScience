% Website translation.
\name{cata_missing}
\alias{cata_missing}
\title{统计缺失值和缺失模式}
\usage{cata_missing(data, by = c("variable", "record", "pattern"))}
\arguments{
\item{data}{数据框。}
\item{by}{汇总层级：变量、记录或缺失模式。}
}
\value{tibble。模式按输入列的顺序编码，\code{1} 表示缺失，\code{0} 表示已观测；\code{variables} 属性记录列顺序。}
\description{按变量、记录或模式统计缺失情况。}
\examples{cata_missing(data.frame(a = c(1, NA), b = c(NA, NA)))}
