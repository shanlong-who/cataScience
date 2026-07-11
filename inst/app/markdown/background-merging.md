## Training lab guide

**Learning objective:** understand why merge keys determine whether joined data
are trustworthy.

**Try this:** merge two files with a key variable, then check row counts and
unmatched records before interpreting the merged table.

**Watch out:** a merge can run without errors and still duplicate records,
drop records, or match the wrong entities.

------------------------------------------------------------------------

## 🧵 Why Do We Merge Datasets?

- Real-world data is rarely in one place

  - One table may hold 🐱cat names and breeds, another table has 🥣cat
    food preferences.

  - You want to analyze how breed relates to diet? You need to merge.

<br>

- Merging is like matchmaking

  - You’re pairing records across two datasets based on matching values
    — like matching “Cat ID” = 007 in both tables.

  - If a cat is missing in one table, do we keep them? Drop them? That’s
    where join types come in!

<img src="images/11-join.png" alt="" width="889" />
