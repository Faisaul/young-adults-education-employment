# Descriptive statistics
# Education and employment among young adults

library(tidyverse)

# Load cleaned data
young <- read_csv(
  "data/clean/cps_young_adults_2024.csv",
  show_col_types = FALSE
)

# Main analysis sample
# Exclude young adults who are still enrolled in high school
analysis <- young %>%
  filter(school_level != "High school" | is.na(school_level))

# Basic summary statistics
summary(analysis$age)
mean(analysis$employed)
mean(analysis$college_enrolled)
mean(analysis$female)
mean(analysis$hispanic)

# Employment rate by college enrollment
analysis %>%
  group_by(college_enrolled) %>%
  summarize(
    observations = n(),
    employment_rate = mean(employed)
  )

# Employment rate by age
analysis %>%
  group_by(age) %>%
  summarize(
    observations = n(),
    employment_rate = mean(employed)
  )

# Employment by age and college enrollment
analysis %>%
  group_by(age, college_enrolled) %>%
  summarize(
    observations = n(),
    employment_rate = mean(employed),
    .groups = "drop"
  )

# Weighted employment rate by college enrollment
analysis %>%
  group_by(college_enrolled) %>%
  summarize(
    employment_rate = weighted.mean(employed, weight)
  )

# Weighted employment rate by age and college enrollment
analysis %>%
  group_by(age, college_enrolled) %>%
  summarize(
    employment_rate = weighted.mean(employed, weight),
    .groups = "drop"
  )