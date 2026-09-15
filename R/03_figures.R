# Figures
# Education and employment among young adults

library(tidyverse)

# Load clean data
young <- read_csv(
  "data/clean/cps_young_adults_2024.csv",
  show_col_types = FALSE
)


# Calculate weighted employment rates
employment_age <- young %>%
  group_by(age, college_enrolled) %>%
  summarize(
    employment_rate = weighted.mean(employed, weight),
    .groups = "drop"
  )


# Add labels
employment_age <- employment_age %>%
  mutate(
    college_status = ifelse(
      college_enrolled == 1,
      "Enrolled in college",
      "Not enrolled in college"
    )
  )


# Make figure
ggplot(
  employment_age,
  aes(
    x = age,
    y = employment_rate,
    color = college_status
  )
) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_y_continuous(
    labels = scales::percent
  ) +
  labs(
    title = "Employment Rates Among Young Adults",
    subtitle = "By age and college enrollment status, October 2024",
    x = "Age",
    y = "Employment rate",
    color = NULL,
    caption = "Source: October 2024 Current Population Survey School Enrollment Supplement"
  ) +
  theme_minimal()


# Save figure
ggsave(
  "output/figures/employment_by_age.png",
  width = 8,
  height = 5
)