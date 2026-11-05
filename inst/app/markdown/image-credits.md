# Image and Asset Credits

This training app uses a mix of generated charts, local training images, and
static assets. Keep this file updated when adding or replacing images.

## Provenance and license

Except for the historical map listed below, images bundled with this app
are the author's own work or were generated with AI tools by the author
(confirmed 2026-07-11). Those images are distributed with the `cataScience`
package under its MIT license.

The John Snow cholera map (`www/snow-cholera-map.jpg`) is from the
[Wellcome Collection](https://wellcomecollection.org/works/dx4prdbj),
image L0072142, marked Public Domain. It depicts the 1854 outbreak and was
published in 1855. A 760-pixel image is bundled for offline teaching.

## App assets

| File or reference | Use | Source |
|---|---|---|
| `www/cata-cats.png` | Shared navbar logo and favicon for both app launchers | AI-generated on 2026-10-30 from the author's photograph of two silver tabby cats (`picture/0-maomi.jpg`), with the package hex logo as a supporting reference |
| `picture/0-maomi.jpg` | Introduction cat image | Author's own / AI-generated |
| `picture/2-workflow.png` | Introduction workflow image | Author's own / AI-generated |
| `www/datasets.zip` | Downloadable exercise datasets | Compiled by the author from WHO/UN public data |

The app icon and website icons under `pkgdown/favicon/` are size and format
derivatives of `pkgdown/assets/cata-cats-master.png` in the source repository.
The app bundles a 192-pixel copy for its 48-pixel navbar display.
The existing package hex logo remains in
`man/figures/logo.png` and the website content. Regenerate website icons
from the package root with `source("pkgdown/build-favicons.R")`.

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
