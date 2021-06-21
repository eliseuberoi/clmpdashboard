### Test functions in roles_functions.R

# Imports ---------------------------------------------------------------------

source("validate.R")

# Mocks -----------------------------------------------------------------------

mock_httr_get_gvt <- function(url) {
    read("get_gvt_posts_mocks_data")
}

mock_httr_get_opp <- function(url) {
    read("get_opp_posts_mocks_data")
}

# Tests -----------------------------------------------------------------------

test_that("get_gvt_posts processes results correctly.", {

    mockery::stub(get_gvt_posts, "httr::GET", mock_httr_get_gvt)

    cols <- c(
        "MNIS_id",
        "Members.Member.ListAs",
        "gvt_role")

    obs <- get_gvt_posts()
    exp <- readRDS("data/get_gvt_posts_data.RData")
    compare_obs_exp(obs, exp, cols, "MNIS_id")
})

test_that("get_opp_posts processes results correctly.", {

    mockery::stub(get_opp_posts, "httr::GET", mock_httr_get_opp)

    cols <- c(
        "MNIS_id",
        "Members.Member.ListAs",
        "opp_role")

    obs <- get_opp_posts()
    exp <- readRDS("data/get_opp_posts_data.RData")
    compare_obs_exp(obs, exp, cols, "MNIS_id")
})
