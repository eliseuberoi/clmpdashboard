### Test functions in appg_functions.R

# Imports ---------------------------------------------------------------------

source("validate.R")

# Mocks -----------------------------------------------------------------------

mock_get_officers <- function(register_date) {
    read("get_officer_data_mocks_data")
}

# Tests -----------------------------------------------------------------------

test_that("get_officer_data processes results correctly.", {

    mockery::stub(get_officer_data, "get_officers", mock_get_officers)

    cols <- c(
        "title",
        "purpose",
        "category",
        "officer_role",
        "officer_name",
        "officer_party")

    obs <- get_officer_data("2021-06-02")
    exp <- readRDS("data/get_officer_data.RData")
    compare_obs_exp(obs, exp, cols, "title")
})


