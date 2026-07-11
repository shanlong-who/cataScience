# Packages attached at startup. Keep this list minimal: every library() call
# here slows down app launch, which matters for the packaged desktop build.
library(tidyverse)
library(shiny)
library(markdown) # shiny::markdown()/includeMarkdown() load it at runtime; keep the dep visible to rsconnect
library(bslib)
library(DT)
library(plotly)
library(rio)
library(readxl) # rio dispatches to readxl for .xlsx; keep the dep visible to rsconnect
library(skimr)
library(naniar)
library(cowplot)

# Heavy packages used at a single call site are accessed with `::` so they are
# loaded lazily instead of at startup:
#   VIM::kNN(), VIM::aggr(), mice::md.pattern(), broom::tidy()

theme_set(theme_minimal_grid())

# Serve the images referenced inside the markdown content pages. The .md files
# use paths relative to markdown/ ("images/…"), which Shiny does not serve by
# default.
addResourcePath("images", "markdown/images")
