## Script to download and prepare the raw data from the Mulligan et al. 2022 survey
library(readr)
library(stringr)
library(dplyr)
library(tidyr)

# download survey responses
raw_survey_data <- read_csv("https://datadryad.org/stash/downloads/file_stream/1034350")

# extract questions
questions <- raw_survey_data |>
  select(starts_with("Q")) |>
  slice_head(n = 1) |>
  mutate(Q42 = str_replace_all(Q42, "\\\n", "")) |>
  pivot_longer(everything(), names_to = "number", values_to = "question")

# isolate responses from paleoanthropologists
paleoanth <- raw_survey_data |>
  filter(str_detect(Q2, "paleoanthropology"),
    Q1 == "Agree")

#usethis::use_data(paleoanth_data, overwrite = TRUE)
write_csv(paleoanth, "data/paleoanth.csv")
write_csv(questions, "data/survey-questions.csv")
