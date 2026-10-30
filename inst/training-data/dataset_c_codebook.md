# Dataset C: Synthetic HIV Facility Metadata

## Purpose and unit

Ten entirely fictional healthcare facilities, one row per facility. This metadata
table supports Session 7 key checks, many-to-one joins, descriptive summaries and charts.
It does not describe actual facilities or a representative Lao PDR population.

## Variables

| Variable | Type | Allowed values / meaning |
|---|---|---|
| facility_id | character | Primary key: A01,A02,B01,B02,C01,C02,D01,D02,E01,E02. Unique, non-missing. Matches Dataset B's non-missing valid facility_id. |
| district | character | Fictional facility location A-E, consistent with observed non-missing district assignments in Dataset B. This does not fill a patient's missing residence. |
| facility_type | character | Hospital or Health Center. Fixed fictional attributes for teaching. |
| vl_service | logical | TRUE: on-site VL testing available. FALSE: no on-site testing; referrals or specimen transport may still enable patient testing. |

## Complete table

| facility_id | district | facility_type | vl_service |
|---|---|---|---|
| A01 | A | Hospital | TRUE |
| A02 | A | Health Center | FALSE |
| B01 | B | Hospital | TRUE |
| B02 | B | Health Center | FALSE |
| C01 | C | Hospital | FALSE |
| C02 | C | Health Center | TRUE |
| D01 | D | Hospital | TRUE |
| D02 | D | Health Center | FALSE |
| E01 | E | Hospital | TRUE |
| E02 | E | Health Center | FALSE |

## Relationship and provenance

Generation reads the finalized Dataset B reference CSV, inspects its facility/district
pairs and stops on conflicting observed assignments. Attribute assignments are fixed
explicitly in validation/generate-dataset-c.R, not estimated from vl_tested or vl_copies.
No randomness is used, so no seed is needed. No source Dataset A or B file is edited.
CSV is UTF-8; logical values are literal TRUE/FALSE, not 0/1 or Yes/No.

The foreign key in B can repeat because many records belong to one facility. Two B
records have missing facility_id and remain unmatched. Two others have missing patient
district but known facility; attaching facility location does not establish residence.
Rename B district to patient_district and C district to facility_district before joining.
Join with facility_id only and na_matches='never'; validate C's unique key and require
relationship='many-to-one'. Preserve all 604 B records for the join audit.

## Interpretation

Facility service availability is not the same variable as an individual patient's reported
2025 testing status. Dataset B encodes vl_tested as Yes, No, Unknown or blank. Never
compare it with TRUE without an explicit conversion. A reported test also does not
guarantee a usable laboratory result. Descriptive group differences are not causal effects.
Refer to Dataset B's codebook and source review for unresolved identity/eligibility issues.
Keep the original input and use a declared analysis subset; no patient population total
or national estimate is inferred from this teaching sample.
