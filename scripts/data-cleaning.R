library(here)
library(readr)
paleoanth_responses <- read_csv(here("data/paleoanth.csv"))

# clean up and group similar responses
paleoanth_responses <- paleoanth |>
  select(!c(DistributionChannel, UserLanguage, Status)) |>
  separate_longer_delim(Q15, delim = regex(",|;")) |>
  # eliminate case differences and remove spaces from start and end
  mutate(Q15 = str_to_lower(Q15),
    Q15 = str_trim(Q15)) |>
  mutate(Q15 = case_when(str_detect(Q15, "supplement") ~ "journal supplementary materials", 
    TRUE ~ Q15)) |>
  mutate(Q15 = case_when(str_detect(Q15, "site") ~ "lab or personal website",
    TRUE ~ Q15)) |>
  # catch specific typos and other cases
  mutate(Q15 = case_match(Q15,
    c("data dryad", "dyad") ~ "dryad",
    c("journal som",
      "j. african earth sciences",
      "j of human evolution",
      "j of human evolution.") ~ "journal supplementary materials",
    "mendelay" ~ "mendeley",
    c("genbank", 
      "genbank etc", 
      "various genome browsers", 
      "ncbi nucleotide", 
      "ena", 
      "gen- bank") ~ "DNA database",
    "zenodo github dryad" ~ "zenodo;github;dryad",
    .default = Q15)) |>
  # recombine to single row per individual
  group_by(ResponseId) |>
  mutate(Q15 = paste0(Q15, collapse = ";")) |>
  distinct(ResponseId, .keep_all = T)

# responses with commas as part of the response and as separator need to be fixed
paleoanth_clean <- paleoanth_responses |>
  # Q17: remove commas following 'e.g.'
  mutate(Q17 = str_remove_all(Q17, "(?<=e.g.),"),
         Q21 = str_remove_all(Q21, "\\([^)]*\\)"))

# create column to distinguish tenured from non-tenured researchers 
paleoanth_tenure <- paleoanth_clean |>
  mutate(tenure = if_else(str_detect(Q3, "\\(tenured\\)"), TRUE, FALSE),
    Q3 = case_when(str_detect(Q3, "full professor") ~ "full professor",
      str_detect(Q3, "associate professor") ~ "associate professor",
      TRUE ~ Q3))

write_csv(paleoanth_tenure, "data/paleoanth-clean.csv")
