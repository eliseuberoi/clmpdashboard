### Download data for unit testing roles_functions.R

# Imports ---------------------------------------------------------------------

source("tests/testthat/validate.R")

# Mocks data ------------------------------------------------------------------

#' Fetch mocks data for unit tests of get_gvt_posts and get_opp_posts
#'
#' @keywords internal

get_gvt_posts_mocks_data <- function() {

    # Download get_gvt_posts
    url_gvt <- stringr::str_c("https://data.parliament.uk/membersdataplatform/",
                              "services/mnis/members/query/house=Commons|",
                              "IsEligible=true|holdsgovernmentpost=true")

    m <- httr::GET(url = url_gvt)
    write(m, "get_gvt_posts_mocks_data")
}

get_opp_posts_mocks_data <- function() {

    # Download get_opp_posts
    url_opp <- stringr::str_c("https://data.parliament.uk/membersdataplatform/",
                              "services/mnis/members/query/house=Commons|",
                              "IsEligible=true|holdsoppositionpost=true")

    m <- httr::GET(url = url_opp)
    write(m, "get_opp_posts_mocks_data")
}


# Validation data -------------------------------------------------------------

#' Fetch validation data for unit tests of get_gvt_posts and get_opp_posts
#'
#' @keywords internal

get_gvt_posts_data <- function() {

    # Download get_gvt_posts
    m <- get_gvt_posts()
    write(m, "get_gvt_posts_data")
}

get_opp_posts_data <- function() {

    # Download get_opp_posts
    m <- get_opp_posts()
    write(m, "get_opp_posts_data")
}

# Fetch all data --------------------------------------------------------------

#' Fetch mocks and validation data for unit tests of roles_functions
#'
#' @keywords internal

get_roles_functions_test_data <- function() {
    get_gvt_posts_mocks_data()
    get_opp_posts_mocks_data()
    get_gvt_posts_data()
    get_opp_posts_data()
}
