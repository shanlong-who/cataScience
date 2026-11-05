% Website translation.
\name{run_cata}
\alias{run_cata}
\title{启动经典版“数据科学之旅”培训应用}
\usage{run_cata(...)}
\arguments{\item{...}{传给 \code{\link[shiny:runApp]{shiny::runApp()}} 的参数，例如 \code{port} 或 \code{launch.browser}。}}
\value{无返回值，调用的作用是启动应用。应用运行期间会占用 R 会话。}
\description{启动包内的交互式培训应用，学习导入、清理、可视化和理解数据，以及安全地与 AI 助手协作。应用在默认浏览器中打开。}
\examples{
# The app is bundled with the package.
app_dir <- system.file("app", package = "cataScience")
file.exists(file.path(app_dir, "app.R"))
if (interactive()) run_cata()
}
