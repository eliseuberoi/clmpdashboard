### Download data for unit testing division_functions.R

# Imports ---------------------------------------------------------------------

source("tests/testthat/validate.R")

# Mocks data ------------------------------------------------------------------

#' Fetch mocks data for unit tests of divisions_functions
#'
#' @keywords internal

get_division_mocks_data <- function() {

    # Download raw data for divisions with ID 736 and 737
    path736 <- stringr::str_c(
        "https://commonsvotes-services.digiminster.com/data/division/",
        "736.json")
    div736 <- httr::GET(url = path736)

    path737 <- stringr::str_c(
        "https://commonsvotes-services.digiminster.com/data/division/",
        "737.json")
    div737 <- httr::GET(url = path737)

    m <- list(div736, div737)
    write(m, "get_division_mocks_data")
}

# Validation data -------------------------------------------------------------

#' Fetch validation data for unit tests of divisions_functions
#'
#' @keywords internal

get_divisions_data_validation_data <- function() {

    # Download get_divisions_data for date of division 736 & 737
    m <- get_divisions_data("2019-12-20", "2019-12-20")
    write(m, "get_divisions_data")
}

# Fetch all data --------------------------------------------------------------

#' Fetch mocks and validation data for unit tests of divisions_functions
#'
#' @keywords internal

get_divisions_test_data <- function() {
    get_division_mocks_data()
    get_divisions_data_validation_data()
}
