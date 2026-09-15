# Descriptive statistics
# Education and employment among young adults

library(tidyverse)

# Load cleaned data
young <- read_csv(
  "data/clean/cps_young_adults_2024.csv",
  show_col_types = FALSE
)


# Basic summary statistics
summary(young$age)
mean(young$employed)
mean(young$college_enrolled)
mean(young$female)
mean(young$hispanic)


# Employment rate by college enrollment
young %>%
  group_by(college_enrolled) %>%
  summarize(
    observations = n(),
    employment_rate = mean(employed)
  )


# Employment rate by age
young %>%
  group_by(age) %>%
  summarize(
    observations = n(),
    employment_rate = mean(employed)
  )


# Employment by age and college enrollment
young %>%
  group_by(age, college_enrolled) %>%
  summarize(
    observations = n(),
    employment_rate = mean(employed),
    .groups = "drop"
  )
# Weighted employment rate by college enrollment
young %>%
  group_by(college_enrolled) %>%
  summarize(
    employment_rate = weighted.mean(employed, weight)
  )


# Weighted employment rate by age and college enrollment
young %>%
  group_by(age, college_enrolled) %>%
  summarize(
    employment_rate = weighted.mean(employed, weight),
    .groups = "drop"
  )