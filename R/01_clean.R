# CPS October 2024
# Education and employment among young adults

library(tidyverse)

# Load data
cps <- read_csv("data/raw/oct24pub.csv")

# Keep people ages 18-24
young <- cps %>%
  filter(PRTAGE >= 18 & PRTAGE <= 24)

# Check sample size
nrow(young)


# Keep the variables we need
young <- young %>%
  select(
    PRTAGE,
    PESEX,
    PEEDUCA,
    PTDTRACE,
    PEHSPNON,
    PESCHENR,
    PESCHFT,
    PESCHLVL,
    PEMLR,
    PWSUPWGT,
    PEHRUSL1
  )

# Rename variables
young <- young %>%
  rename(
    age = PRTAGE,
    sex = PESEX,
    education = PEEDUCA,
    race = PTDTRACE,
    hispanic = PEHSPNON,
    enrolled = PESCHENR,
    full_time = PESCHFT,
    school_level = PESCHLVL,
    labor_status = PEMLR,
    weight = PWSUPWGT,
    usual_hours = PEHRUSL1
  )

# Sex
# 1 = male, 2 = female

young <- young %>%
  mutate(
    female = ifelse(sex == 2, 1, 0)
  )


# Hispanic ethnicity
# 1 = Hispanic, 2 = non-Hispanic

young <- young %>%
  mutate(
    hispanic = ifelse(hispanic == 1, 1, 0)
  )

# Group race into broader categories

young <- young %>%
  mutate(
    race_group = case_when(
      race == 1 ~ "White",
      race == 2 ~ "Black",
      race == 4 ~ "Asian",
      TRUE ~ "Other"
    )
  )
# Recode school enrollment
# 1 = enrolled
# 2 = not enrolled

young <- young %>%
  mutate(
    enrolled = ifelse(enrolled == 1, 1,
                      ifelse(enrolled == 2, 0, NA))
  )


# Recode employment
# PEMLR 1 or 2 = employed
# PEMLR 3-7 = not employed

young <- young %>%
  mutate(
    employed = ifelse(labor_status %in% c(1, 2), 1,
                      ifelse(labor_status %in% c(3, 4, 5, 6, 7), 0, NA))
  )


# Create simple labels for school level
young <- young %>%
  mutate(
    school_level = ifelse(school_level == 1, "High school",
                          ifelse(school_level == 2, "College", NA))
  )
# College enrollment
# 1 = currently enrolled in college
# 0 = not currently enrolled in college

young <- young %>%
  mutate(
    college_enrolled = ifelse(
      enrolled == 1 & school_level == "College",
      1,
      0
    )
  )

# Usual weekly hours at main job
# Negative values are CPS special codes

young <- young %>%
  mutate(
    usual_hours = ifelse(usual_hours >= 0, usual_hours, NA)
  )

# Remove observations missing enrollment or employment information
young_clean <- young %>%
  filter(
    !is.na(enrolled),
    !is.na(employed),
    weight > 0
  )


# Check final sample
nrow(young_clean)

table(young_clean$enrolled)
table(young_clean$employed)
table(young_clean$school_level, useNA = "ifany")


# Save clean data
write_csv(
  young_clean,
  "data/clean/cps_young_adults_2024.csv"
)