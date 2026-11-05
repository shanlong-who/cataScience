% Website translation.
\name{cata_profile}
\alias{cata_profile}
\title{汇总数据表的结构与质量}
\usage{cata_profile(data)}
\arguments{\item{data}{数据框。}}
\value{每个变量一行，包含存储类型、记录数、已观测不同值数量、缺失情况及数值汇总。不修改任何值。}
\description{在开始分析前检查数据结构与基本质量。}
\examples{cata_profile(data.frame(id = c("001", "002"), value = c(3, NA)))}
