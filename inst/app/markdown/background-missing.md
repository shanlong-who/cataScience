## Training lab guide

**Learning objective:** distinguish between detecting missing data and deciding
what the missing data means.

**Try this:** upload a dataset with missing values, inspect which variables and
rows are affected, then compare row removal with one imputation method.

**Watch out:** filling missing values can make a dataset look complete while
reducing uncertainty or hiding bias. Always ask why the value is missing before
choosing a method.

------------------------------------------------------------------------

## 🐾 What is missing data?

- Imagine you’re collecting data about cats — their age, height,
  favorite toy…

- But oops! Some cats forgot to tell you their favorite toy. That’s
  **missing data**.

- In technical terms, missing data refers to the absence of a value
  where one is expected.

------------------------------------------------------------------------

## 🧠 Why does it matter?

- It can **bias your analysis** (like judging a cat’s weight without
  knowing half of them!)

- Some models **refuse to work** with missing values

- It hides **important patterns** in your data

------------------------------------------------------------------------

## 🧭 Where Does It Come From?

- 📝 People forget to fill in a form

- 💻 Sensors fail to record

- 🧹 Data gets deleted or corrupted

------------------------------------------------------------------------

> 🐱 Even cats don’t always cooperate with data collection. That’s why
> we clean up their mess — statistically!
