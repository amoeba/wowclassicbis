library(googlesheets4)
library(readr)

credentials <- Sys.getenv("SHEETS_CREDENTIALS")
# Debug

print(nchar(credentials))

stopifnot(is.character(credentials))

gs4_auth(email = "petridish@gmail.com", credentials)

archive_target <- function(target) {
  stopifnot("url" %in% names(target))
  stopifnot("sheets" %in% names(target))

  lapply(target$sheet, function(sheet_name) {
    sheet <- googlesheets4::read_sheet(target$url, sheet_name)
    path <- paste0(sheet_name, ".csv")
    readr::write_csv(sheet, path)

    path
  })
}

archive_targets <- function(targets) {
  lapply(targets, archive_target)
}

targets = list(
  "MySheet" = list(
    url = "https://docs.google.com/spreadsheets/d/1EytnNHuosjE7Iu4pjVVMZPJifnCOxpvPwRxcjO5xYMU/edit#gid=0",
    sheets = c("MySheet", "MyOtherSheet")
  )
)

archive_targets(targets)

