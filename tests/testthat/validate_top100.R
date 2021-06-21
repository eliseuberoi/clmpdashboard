### Download data for unit testing top100.R

# Imports ---------------------------------------------------------------------

source("tests/testthat/validate.R")

# Mocks data ------------------------------------------------------------------

#' Fetch mocks data for unit tests of get_top100
#'
#' @keywords internal

get_top100_mocks_data <- function() {

    # Download mocks data for test period 2020-03-01 until 2020-03-08 and
    # join with member data
    contributions <- clparlysearch::fetch_all_contributions("2020-03-01", "2020-03-08", 19,21)
    contributions$full_name <- get_full_name(contributions$member)
    joined <- join_and_match(contributions)
    m <- joined$joined_data

    write(m, "get_top100_mocks_data")
}

# Validation data -------------------------------------------------------------

#' Fetch validation data for unit tests of get_top100
#'
#' @keywords internal

get_top100_data <- function() {

    # Download data first
    contributions <- clparlysearch::fetch_all_contributions("2020-03-01", "2020-03-08", 19,21)
    contributions$full_name <- get_full_name(contributions$member)
    joined <- join_and_match(contributions)
    contributions_joined <- joined$joined_data

    # Process
    m <- get_top100(contributions_joined)
    write(m, "get_top100_data")
}

# Fetch all data --------------------------------------------------------------

#' Fetch mocks and validation data for unit tests of get_top100
#'
#' @keywords internal

get_top100_test_data <- function() {
    get_top100_mocks_data()
    get_top100_data()
}
