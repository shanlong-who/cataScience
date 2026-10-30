# Run from the package root after changing the shared Shiny cat icon.
# Keep the website's original hex logo in man/figures/logo.png.
library(magick)
library(base64enc)

source.path <- "inst/app/www/cata-cats.png"
output.dir <- "pkgdown/favicon"
dir.create(output.dir, recursive = TRUE, showWarnings = FALSE)

icon <- image_read(source.path)
sizes <- c(16L, 32L, 48L, 96L, 180L, 192L, 512L)
icons <- lapply(sizes, function(size) {
  image_strip(image_resize(icon, paste0(size, "x", size, "!")))
})
names(icons) <- as.character(sizes)

for (size in c(16L, 32L, 48L, 96L)) {
  image_write(icons[[as.character(size)]],
    file.path(output.dir, paste0("favicon-", size, "x", size, ".png")), format = "png")
}
image_write(icons[["180"]], file.path(output.dir, "apple-touch-icon.png"), format = "png")
image_write(icons[["192"]], file.path(output.dir, "web-app-manifest-192x192.png"), format = "png")
image_write(icons[["512"]], file.path(output.dir, "web-app-manifest-512x512.png"), format = "png")
image_write(image_join(icons[c("16", "32", "48")]),
  file.path(output.dir, "favicon.ico"), format = "ico")

# Embed the same artwork so the SVG has no external image dependencies.
png.data <- base64encode(image_write(icons[["192"]], format = "png"))
svg <- paste0('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 192 192">',
  '<image width="192" height="192" href="data:image/png;base64,', png.data,
  '"/></svg>')
writeLines(svg, file.path(output.dir, "favicon.svg"), useBytes = TRUE)

manifest <- c(
  '{',
  '  "name": "cataScience",',
  '  "short_name": "cataScience",',
  '  "icons": [',
  '    {"src":"web-app-manifest-192x192.png","sizes":"192x192","type":"image/png","purpose":"any"},',
  '    {"src":"web-app-manifest-512x512.png","sizes":"512x512","type":"image/png","purpose":"any"}',
  '  ],',
  '  "theme_color": "#0093D5",',
  '  "background_color": "#fffdf2",',
  '  "display": "standalone"',
  '}'
)
writeLines(manifest, file.path(output.dir, "site.webmanifest"), useBytes = TRUE)

stopifnot(all(vapply(seq_along(sizes), function(i) {
  info <- image_info(icons[[i]])
  info$width == sizes[i] && info$height == sizes[i]
}, logical(1))))
