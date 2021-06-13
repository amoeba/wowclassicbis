library(googlesheets4)
library(jsonlite)
library(readr)
library(dplyr)
library(base64enc)

# Credentials
CREDENTIALS <- Sys.getenv("CREDENTIALS")
SHEET_IDS <- strsplit(Sys.getenv("SHEET_IDS"), ",")[[1]]
CREDENTIALS_BINARY <- base64enc::base64decode(CREDENTIALS)
CREDENTIALS_DECODED <- tempfile()
writeBin(CREDENTIALS_BINARY, CREDENTIALS_DECODED)

# Auth
googlesheets4::gs4_auth(path = CREDENTIALS_DECODED)

# process_sheet
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

lapply(SHEET_IDS, process_sheet)
