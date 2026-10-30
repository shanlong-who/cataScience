# Dataset B: Synthetic HIV ART Patient Data

Fixed seed: **20261116**. Generated using R 4.6.0, the default Mersenne-Twister RNG,
Inversion normal generator and Rejection sampling. Generation code is in
`slides/session06/validation/generate-dataset-b.R`. No real patient information is used.

## Population and observation unit

Intended population: adults aged at least 18 receiving ART for at least six months in 2025.
One intended observation is one person's annual programme record for 2025. The
extract has **604 rows and 600 distinct patient IDs**: 600 initial records plus
four deliberately added records. Counts or invalid fields may contradict eligibility;
flag those contradictions rather than silently excluding patients or inventing corrections.
This is an independent ART teaching sample. It is not nationally representative and
must not be reconciled to Dataset A's aggregate counts. Districts and facilities are fictional.

## Raw fields (CSV order)

| Field | Storage after read_csv() | Definition and coding |
|---|---|---|
| patient_id | character | Fictional programme ID B0001-B0600; repeated IDs require review. |
| age | numeric | Recorded age in years in 2025. Blank is missing. For this exercise, ages below 18 or above 110 require eligibility/value review. This screen is not proof of an error. |
| sex | character | Female/Male are standard labels. F/female map to Female; M/male map to Male under the supplied dictionary. Unknown and blanks convey no known category; '?' has no documented mapping. |
| district | character | Recorded fictional district A-E. Blank is unresolved; do not infer residence from a facility ID. |
| facility_id | character | Fictional ART facility A01,A02,B01,B02,C01,C02,D01,D02,E01,E02. Blank is unresolved. No real facilities or contact details. |
| art_months | numeric | Recorded completed months on ART at the 2025 annual snapshot. Blank is missing; values below 6 require eligibility/source review. |
| vl_tested | character | Yes: a VL test is reported in 2025. No: no test is reported. Unknown: status cannot be established. Blank: status not recorded. Status alone does not establish that a usable result exists. |
| vl_copies | numeric | Included recorded VL result in copies/mL. Blank is missing, not zero. Negative values are invalid numerical results. Nonnegative high values can be valid; no upper deletion rule is justified here. Values are synthetic exact numbers, not censored laboratory strings. |

## Visit, result and duplicate interpretation

The intended annual dataset has no visit date, test date or visit ID. A repeated patient
ID therefore cannot be resolved by choosing a 'latest' row. In a visit-level file, repeated
IDs may represent valid visits; here, investigate the extraction/source before choosing.
`dataset_b_source_review.csv` supplies the available synthetic audit evidence.
`source_row` means the row number immediately after import, starting at 1 for the first
data row (CSV line 2). Assign it before any sorting or transformation.

No raw row is deleted. Confirmed extraction copies are marked separately from unresolved
repeat IDs. A reference file with flags is not a fully resolved one-row-per-person dataset.

## VL interpretation

No + missing result can be expected. Yes + missing result requires follow-up.
No + recorded result is a contradiction requiring review; do not guess the correct status.
Unknown/blank status needs clarification, whether or not a result is recorded.
For the optional suppression example only: require Yes plus a non-missing, nonnegative
result. Suppressed means **strictly less than 1,000 copies/mL**; 1,000 is not below the
threshold. Otherwise keep suppression unavailable. A synthetic value of zero is a valid
number here; it is not a substitute for a missing result. This is an exercise coding rule,
not a clinical interpretation of a real laboratory reporting limit.

## Reference-clean file

All 604 rows and all eight raw columns are preserved. Added fields record source row,
analysis age, standard sex, analysis VL, review flags and record_action.
Out-of-screen ages and negative VL results are unavailable in separate analysis columns;
raw values remain untouched. Unknown categories are not guessed. No clinical measurement
is imputed. Only confirmed source evidence can justify changing a duplicate's action.
Resolve outstanding issues and define an analysis population before calculating patient totals.

## Reuse of facility IDs

The ten stable fictional IDs are reserved for later training compatibility. This file
does not provide Dataset C or teach joins. No Session 7 material is generated.
