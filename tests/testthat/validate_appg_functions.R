### Download data for unit testing appg_functions.R

# Imports ---------------------------------------------------------------------

source("tests/testthat/validate.R")

# Mocks data ------------------------------------------------------------------

#' Fetch mocks data for unit tests of get_members
#'
#' @keywords internal

get_officer_data_mocks_data <- function() {

    # Download officer data for 2021-06-02
    parlygroups::download_appg("2021-06-02")
    m <- parlygroups::appg_officers()
    write(m, "get_officer_data_mocks_data")
}

# Validation data -------------------------------------------------------------

#' Fetch validation data for unit tests of get_members
#'
#' @keywords internal

get_officer_data_validation_data <- function() {

    # Download get_officer_data
    m <- get_officer_data("2021-06-02")
    write(m, "get_officer_data")
}

# Fetch all data --------------------------------------------------------------

#' Fetch mocks and validation data for unit tests of get_members
#'
#' @keywords internal

get_appg_test_data <- function() {
        get_officer_data_mocks_data()
        get_officer_data_validation_data()
}
