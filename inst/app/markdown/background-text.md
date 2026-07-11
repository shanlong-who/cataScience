## Training lab guide

**Learning objective:** see how small text inconsistencies become false
categories in descriptive statistics and plots.

**Try this:** standardize casing and labels, then compare frequency tables
before and after cleaning.

**Watch out:** text replacement can create new errors if the matching rule is
too broad. Check a sample of changed rows before trusting the result.

------------------------------------------------------------------------

## Why do we need text cleaning?

- Messy text is everywhere — people write “USA”, “U.S.A.”, and “the
  States”, but we just want one version!

- Text models are picky — “Doctor”, “doctor”, and “DOCTOR” look the same
  to humans, but not to machines.

- Grouping, filtering, searching… all get confused when spelling or
  casing isn’t consistent.

- Think of raw text like unfiltered juice — tasty, but full of pulp
  (a.k.a. mess).

- Solution? Clean the text before doing anything smart with it!

## What can we do?

- Change text casing

  - Want it ALL UPPER, all lower, Like Title, or Like a sentence?

<br>

- Find and replace

  - Replace every “M” with “male”.
