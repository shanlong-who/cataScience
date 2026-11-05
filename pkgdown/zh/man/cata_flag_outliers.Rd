% Website translation.
\name{cata_flag_outliers}
\alias{cata_flag_outliers}
\title{标记待检查值，不改变原始数据}
\usage{cata_flag_outliers(x, k = 1.5, limits = NULL)}
\arguments{
\item{x}{数值向量。}
\item{k}{IQR 规则的非负倍数。}
\item{limits}{可选的数值下限和上限，边界本身视为范围内。}
}
\value{保留每一行和每个原始值的 tibble，同时给出边界、检查标记和原因。缺失值的异常标记为未知。}
\description{IQR 标记是筛查结果，不能证明数值错误。只有存在有依据的规则时，才应指定 \code{limits}。}
\examples{cata_flag_outliers(c(1:9, 100, NA))}
