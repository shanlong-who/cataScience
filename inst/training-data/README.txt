Training data provenance

These are Shanlong Ding's synthetic materials for the November 2026 Lao
training. They are fictional teaching data, not country or patient records.
The files were copied without modification from the training slides source:

Dataset_A_Student.xlsx: session03/assets/
dataset_b_raw.csv, dataset_b_clean_reference.csv,
dataset_b_source_review.csv, dataset_b_codebook.md,
dataset_c.csv, dataset_c_codebook.md: session11/data/

Dataset A has 15 district-year rows and is independent of datasets B/C.
Do not link it to the patient-level examples or interpret S/T as suppression
among all ART patients. The workbook includes its codebook and scenarios.

Dataset B has 604 rows. The clean reference retains the raw records and
adds review flags; it is not an instruction to delete all repeated IDs.
The source-review table distinguishes identical records, corrected repeats,
follow-up records and unresolved cases. Read its codebook before selection.

Dataset C has ten fictional facilities and links to B by facility_id.
The reference left join keeps 604 records, including two unmatched rows.
The Session 7 selection keeps 587; complete model predictors leave 575.
The packaged cata_lao_analysis() documents each denominator separately.

These author-supplied teaching materials are distributed with cataScience
under its MIT license. The original training files are not modified by
loading, reviewing or exporting them through cataScience.
