library(googlesheets4)
library(jsonlite)
library(readr)
library(dplyr)

# Credentials
credentials_path <- tempfile()
writeLines(Sys.getenv("CREDENTIALS"), credentials_path)
print(file.exists(credentials_path))
print(nchar(Sys.getenv("CREDENTIALS")))
googlesheets4::gs4_auth(path = credentials_path)

# Setup
sheet_ids <- strsplit(Sysgetenv("SHEET_IDS"), ",")[[1]]

process_sheet <- function(sheet_id) {
  info <- googlesheets4::gs4_get(sheet_id)
  sheet_names <- info$sheets$name

  lapply(sheet_names, function(name) {
    sheet_tibble <- googlesheets4::read_sheet(sheet_id, sheet = name)
    sheet_tibble %>%
      dplyr::mutate_all(as.character) -> sheet_tibble

    readr::write_csv(sheet_tibble, paste0(name, ".csv"))

    name
  })
}

lapply(sheet_ids, process_sheet)
