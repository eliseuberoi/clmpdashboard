### Download data for unit testing get_members.R

# Imports ---------------------------------------------------------------------

source("tests/testthat/validate.R")

# Mocks data ------------------------------------------------------------------

#' Fetch mocks data for unit tests of get_members
#'
#' @keywords internal

get_members_mocks_data <- function() {

    # Download get_member_data
    path <- stringr::str_c(
        "http://data.parliament.uk/membersdataplatform/services/",
        "mnis/members/query/house=Commons|IsEligible=true")
    m <- httr::GET(url = path)
    write(m, "get_member_data_mocks_data")
}

# Validation data -------------------------------------------------------------

#' Fetch validation data for unit tests of get_members
#'
#' @keywords internal

get_members_validation_data <- function() {

    # Download get_member_data
    m <- get_member_data()
    write(m, "get_member_data")
}

# Fetch all data --------------------------------------------------------------

#' Fetch mocks and validation data for unit tests of get_members
#'
#' @keywords internal

get_members_test_data <- function() {
    get_members_mocks_data()
    get_members_validation_data()
}
