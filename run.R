library(googlesheets4)
library(readr)


gs4_auth(path = "service-account.json")

archive_target = function(target) {
  stopifnot("url" %in% names(target))
  stopifnot("sheets" %in% names(target))

  lapply(target$sheet, function(sheet_name) {
    sheet <- read_sheet(target$url, sheet_name)
    path <- paste0(sheet_name, ".csv")
    write_csv(sheet, path)

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

