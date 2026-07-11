# Data-quality lab script (20–30 minutes)

A guided lab for the Import → Cleaning → Visualize modules. The purpose is
to slow participants down and make them check data quality before trusting
any analysis — their own, or one written by AI.

## Learning goals

By the end of this lab, participants should be able to:

- inspect whether a dataset is analysis-ready;
- explain why missing values and outliers are not only technical problems;
- compare at least two cleaning choices;
- describe how a cleaning decision can change a chart or policy message.

## Suggested timing

| Time | Activity | Instructor prompt |
|---|---|---|
| 3 min | Frame the lab | "AI can help write code, but it cannot know whether the data make sense unless we check." |
| 5 min | Import and inspect | "What would you check before asking AI to summarize this file?" |
| 7 min | Missing values | "Which missing values are harmless, and which could bias an indicator?" |
| 7 min | Outliers | "Is this value wrong, rare, or important?" |
| 5 min | Visualization | "Does the chart answer the question, or only produce a plot?" |
| 3 min | Debrief | "What should we ask AI to revise after seeing the data quality issues?" |

## Recommended lab path

1. Open **Import** and load `cat-dirty-data.xlsx` (example data button).
2. Ask participants to inspect rows, columns, variable names, data types,
   and obvious formatting problems.
3. Move to **Cleaning → Missing data**.
4. Compare row removal with mean, median, or kNN imputation.
5. Ask participants to describe one assumption behind each method.
6. Move to **Cleaning → Outliers**.
7. Use the boxplot to identify flagged values.
8. Compare removing outliers with winsorizing.
9. Move to **Visualize**.
10. Create one chart before and after cleaning.
11. Ask whether the message changed.

## Questions to ask participants

- What would an AI tool likely do if we asked it to "clean this data"
  without context?
- Which values should be checked against the original source?
- Which cleaning choices need to be documented in a policy brief?
- Did cleaning change the denominator, the distribution, or the conclusion?
- What should we never automate without human review?

## Linking the lab to interpretation

End the lab by connecting data quality to interpretation:

- Missingness can create bias.
- Outliers can represent errors or meaningful inequity.
- Correlation can appear stronger or weaker after cleaning.
- A clean-looking chart can still support a weak causal claim.

This sets up the follow-on group activity: critiquing an AI-generated
analysis with the **critique checklist** (next panel) and turning it into a
cautious, useful policy brief.
