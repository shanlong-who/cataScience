This updates cataScience 2.2.0 to 3.0.0 after field use in a training workshop.

The major version marks the removal of two exported functions. Users of
run_catas() can switch to run_cata() for the English or Chinese classroom.
The workshop-specific cata_lao_analysis() function and its HIV examples
have been retired. These changes are described in NEWS.

The classroom now lets learners verify and correct individual values while
preserving the original data. Joins, charts and exports use the analysis
values. The two original cat workbooks are included without changes.

The same source archive was checked with R CMD check --as-cran on
Ubuntu 26.04.1 LTS on 23 November 2026:
- R 4.6.2: 0 errors, 0 warnings, 0 notes.
- R-devel (r90959): 0 errors, 0 warnings, 0 notes.

Both runs included incoming checks, examples, tests, vignette rebuilds,
and the PDF and HTML manuals. The same source commit also passed the
repository checks on Windows, macOS and Linux (release, devel and oldrel-1
on Linux). The CRAN source index on 23 November 2026 listed no reverse
dependencies in Depends, Imports, LinkingTo, Suggests or Enhances.

Source commit: eeb63348250c4d0d237bf0ef83c42778fe667791.
Source archive: 6,412,259 bytes.
SHA-256: 1c8faeeb67797ef341704a12a26393090dc93d7a8c5fe2b059d1a59a30f1e22d.
