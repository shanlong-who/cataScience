% Website translation.
\name{cata_proportion}
\alias{cata_proportion}
\title{使用明确分母计算比例}
\usage{cata_proportion(numerator, denominator, scale = 100)}
\arguments{
\item{numerator, denominator}{数值计数，长度相同，或其中一个为单值。}
\item{scale}{乘数，计算百分比时通常为 100。}
}
\value{tibble，包含输入计数、\code{value} 和 \code{status}。无效计数或零分母得到 NA，并保留原因。}
\description{明确保留分子和分母，并记录无法计算比例的原因。}
\examples{cata_proportion(c(200, 233, 0), c(265, 315, 0))}
