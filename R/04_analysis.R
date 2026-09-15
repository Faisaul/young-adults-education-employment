# Regression analysis
# Education and employment among young adults

library(tidyverse)
library(fixest)
library(modelsummary)
# Load clean data
young <- read_csv(
  "data/clean/cps_young_adults_2024.csv",
  show_col_types = FALSE
)


# Remove people currently enrolled in high school
analysis <- young %>%
  filter(
    school_level != "High school" | is.na(school_level)
  )

# Check sample
nrow(analysis)

table(analysis$college_enrolled)
table(analysis$employed)


# # Model 1
model1 <- feols(
  employed ~ college_enrolled,
  data = analysis,
  weights = ~weight,
  vcov = "hetero"
)

# Model 2
model2 <- feols(
  employed ~ college_enrolled + factor(age),
  data = analysis,
  weights = ~weight,
  vcov = "hetero"
)

# Model 3
model3 <- feols(
  employed ~ college_enrolled +
    factor(age) +
    female +
    hispanic +
    factor(race_group),
  data = analysis,
  weights = ~weight,
  vcov = "hetero"
)
# Model 4
# Allow the college enrollment relationship to vary by age

model4 <- feols(
  employed ~ college_enrolled * factor(age) +
    female +
    hispanic +
    factor(race_group),
  data = analysis,
  weights = ~weight
)

summary(model4)

models <- list(
  "Raw" = model1,
  "Age controls" = model2,
  "Demographic controls" = model3
)

modelsummary(
  models,
  coef_map = c(
    "college_enrolled" = "College enrolled"
  ),
  stars = TRUE,
  output = "output/tables/regression_table.html"
)

# ------------------------------------------------------------
# Hours worked among employed young adults
# ------------------------------------------------------------

# Keep employed people with valid usual hours
workers <- analysis %>%
  filter(
    employed == 1,
    !is.na(usual_hours)
  )

# Check sample
nrow(workers)

# Weighted average hours by college enrollment
workers %>%
  group_by(college_enrolled) %>%
  summarize(
    observations = n(),
    average_hours = weighted.mean(usual_hours, weight)
  )


# Model 5
# Raw difference in usual weekly hours
hours1 <- feols(
  usual_hours ~ college_enrolled,
  data = workers,
  weights = ~weight,
  vcov = "hetero"
)

summary(hours1)


# Model 6
# Add age and demographic controls
hours2 <- feols(
  usual_hours ~ college_enrolled +
    factor(age) +
    female +
    hispanic +
    factor(race_group),
  data = workers,
  weights = ~weight,
  vcov = "hetero"
)

summary(hours2)

# Hours regression table

hours_models <- list(
  "Raw" = hours1,
  "Demographic controls" = hours2
)

modelsummary(
  hours_models,
  coef_map = c(
    "college_enrolled" = "College enrolled"
  ),
  stars = TRUE,
  output = "output/tables/hours_regression_table.html"
)