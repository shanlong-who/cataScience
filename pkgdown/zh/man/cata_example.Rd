% Website translation.
\name{cata_example}
\alias{cata_example}
\title{加载有文档说明的示例数据}
\usage{cata_example(name = NULL)}
\arguments{\item{name}{示例名称。NULL 返回示例目录。}}
\value{带有 \code{cata_source} 属性的 tibble，或示例目录。教学数据 A、B、C 均为合成数据。A 与 B/C 独立，不应关联到个人 ART 记录。}
\description{加载包内示例及其来源信息。}
\examples{
cata_example()
cats <- cata_example("cats")
}
