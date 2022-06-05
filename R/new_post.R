
new_post <- function(type = "programming", title = "Moving to quarto"){
  
  use_title <- gsub(pattern = " ", replacement = "-", tolower(title))
  new_location <- file.path(here::here(type), 
                            paste0(format(Sys.Date(), "%Y-%m-%d"),"-",use_title),
                            "index.qmd")
  fs::dir_create(dirname(new_location), recurse = TRUE)
  fs::file_create(path = new_location)
  use_date <- format(Sys.Date(), "%Y-%m-%d")
  front_matter <- glue::glue('
---
title: "{title}"
description: |
  whatcha writing about? 
date: {use_date}
categories:  [Bayes, Covid-19, Clinical Trials, Stan, Causal Inference]
---
')
  
  writeLines(front_matter, new_location)
  
  if (interactive()) {
    rstudioapi::navigateToFile(new_location)
  }
  
}