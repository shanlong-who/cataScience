% Website translation.
\name{cata_lao_analysis}
\alias{cata_lao_analysis}
\title{复现老挝培训的合成数据分析}
\usage{cata_lao_analysis()}
\value{列表，包含关联和筛选后的记录、关联审计、状态汇总、分析流程、卡方检验、逻辑回归模型及比值比表。常规模型区间未考虑机构内相关性。}
\description{使用内置 B/C 参考文件及课程声明的筛选规则。这是完整教学示例，不是国家估计，也不是通用临床分析函数。报告已检测与检测结果可获得性、病毒抑制是不同概念。}
\examples{
lesson <- cata_lao_analysis()
lesson$flow
}
