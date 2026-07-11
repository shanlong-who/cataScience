# Image and Asset Credits

This training app uses a mix of generated charts, local training images, and
static assets. Keep this file updated when adding or replacing images.

## Provenance and license

All images bundled with this app are the author's own work or were generated
with AI tools by the author (confirmed 2026-07-11). They are distributed with
the `cataScience` package under its MIT license.

## App assets

| File or reference | Use | Source |
|---|---|---|
| `www/1-logo.jpg` | Navbar logo and favicon | Author's own / AI-generated |
| `picture/0-maomi.jpg` | Introduction cat image | Author's own / AI-generated |
| `picture/2-workflow.png` | Introduction workflow image | Author's own / AI-generated |
| `www/datasets.zip` | Downloadable exercise datasets | Compiled by the author from WHO/UN public data |

## Markdown lesson images

The figures under `markdown/images/` (dirty-data examples, join diagrams,
chart-type examples, outlier and missing-data illustrations, and the cat
story illustrations) are the author's own work or AI-generated illustrations
made by the author.

Oversized originals were compressed on 2026-07-11 (resized to a maximum
width of 1400 px and palette-quantized where lossless); originals are
recoverable from git history if a print-quality version is ever needed.

## External assets removed

- The introduction page previously loaded a GIF directly from Giphy. This was
  replaced with the local `www/1-logo.jpg` asset so the app works offline and
  avoids an undocumented external media dependency.
