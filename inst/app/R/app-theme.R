# Application theme. Colours follow the Okabe-Ito colour-blind-safe palette,
# with the blue close to the WHO brand blue. Fonts use the system stack only:
# the packaged desktop build must work fully offline, so no CDN web fonts.
app_theme <- bs_theme(
  version = 5,
  preset = "shiny",
  primary = "#0072B2",
  secondary = "#5C6B73",
  success = "#009E73",
  warning = "#E69F00",
  danger = "#D55E00",
  info = "#56B4E9",
  base_font = font_collection(
    "system-ui", "-apple-system", "Segoe UI", "Helvetica Neue", "Arial", "sans-serif"
  ),
  heading_font = font_collection(
    "system-ui", "-apple-system", "Segoe UI Semibold", "Segoe UI", "Helvetica Neue", "Arial", "sans-serif"
  ),
  code_font = font_collection(
    "Cascadia Code", "Consolas", "Courier New", "monospace"
  ),
  "navbar-dark-bg" = "#0072B2",
  "navbar-light-bg" = "#0072B2",
  "body-bg" = "#f8fafc", # Soft grey-blue background for layered card depth
  "card-border-radius" = "0.8rem"
)
