% Website translation.
\name{run_catas}
\alias{run_catas}
\title{启动 cataScience 扩展培训版}
\usage{run_catas(..., language = c("auto", "en", "zh"))}
\arguments{\item{...}{传给 \code{\link[shiny:runApp]{shiny::runApp()}} 的参数。}
\item{language}{\code{"zh"} 为简体中文，\code{"en"} 为英文。默认的 \code{"auto"} 优先采用保存的选择，再依据浏览器语言。可在顶部菜单切换。}}
\value{调用的作用是启动应用；应用运行期间会占用 R 会话。}
\description{在经典培训应用上增加引导式工作流、公共卫生案例、带审计记录的数据准备、更多图表、多重插补教学，以及报告和 dashboard 导出。本地版核心活动可离线运行。}
\examples{if (interactive()) run_catas()}
\seealso{\code{\link[=run_cata]{run_cata()}}}
