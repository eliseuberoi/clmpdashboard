### Download data for unit testing edms_functions.R

# Imports ---------------------------------------------------------------------

source("tests/testthat/validate.R")

# Mocks data ------------------------------------------------------------------

#' Fetch mocks data for unit tests of get_emds_list and get_edms_signatures
#'
#' @keywords internal

get_edms_list_mocks_data <- function() {

    # Download get_edms_list for test period 2020-03-01 until 2020-03-08

    url <- paste0("https://oralquestionsandmotions-api.parliament.uk/EarlyDayMotions/list?parameters.tabledStartDate=",
                  "2020-03-01", "&parameters.tabledEndDate=", "2020-03-08",
                  "&parameters.statuses=Published&parameters.take=100", collapse = ", ")

    m <- httr::GET(url)

    write(m, "get_edms_list_mocks_data")
}

get_edms_signatures_mocks_data <- function() {

    # Download get_edms_signatures for test edm id 56795

    url <- paste0("https://oralquestionsandmotions-api.parliament.uk/EarlyDayMotion/",
                  56795, collapse =  ", ")

    m <- httr::GET(url)

    write(m, "get_edms_signatures_mocks_data")
}


# Validation data -------------------------------------------------------------

#' Fetch validation data for unit tests of get_edms_list and get_edms_signatures
#'
#' @keywords internal

get_edms_list_data <- function() {

    # Download get_edms_list
    m <- get_edms_list("2020-03-01", "2020-03-08")
    write(m, "get_edms_list_data")
}

get_edms_signatures_data <- function() {

    # Download get_edms_signatures
    m <- get_edms_signatures(56795)
    write(m, "get_edms_signatures_data")
}

# Fetch all data --------------------------------------------------------------

#' Fetch mocks and validation data for unit tests of edms_functions
#'
#' @keywords internal

get_edms_test_data <- function() {
    get_edms_list_mocks_data()
    get_edms_signatures_mocks_data()
    get_edms_list_data()
    get_edms_signatures_data()
}
