# FAIR Sharing is Caring

Poster presented at [ESHE 2023](https://eshe.eu/meetings/).

Contents:

- Analysis
  + data retrieval: `data-raw/DATASET.R`
  + data cleaning: `scripts/data-cleaning.R`
  + processed survey data: `data/paleoanth-clean.csv`
  + survey questions: `data/survey-questions.csv`


- Report
  + rendered: `poster-analysis.html` or <https://bbartholdy.github.io/eshe2023-data-sharing/poster-analysis.html>
  + source code: `poster-analysis.qmd`
  + references cited: `references.bib`

## Reproduce results

Open [RStudio](https://posit.co/download/rstudio-desktop/)

Open Project > eshe2023-data-sharing.Rproj or click on the file in the file pane

Run `renv::restore()` in the console.

Run `quarto::quarto_render("poster-analysis.qmd")`
