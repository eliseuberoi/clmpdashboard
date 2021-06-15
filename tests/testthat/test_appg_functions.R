### Test functions in appg_functions.R

# Imports ---------------------------------------------------------------------

source("validate.R")

# Mocks -----------------------------------------------------------------------

mock_parlygroups <- function(register_date) {
    read("get_officer_data_mocks_data")
}

# Tests -----------------------------------------------------------------------

test_that("get_officer_data processes results correctly.", {

    mockery::stub(get_officer_data, "parlygroups::download_appg", mock_parlygroups)

    cols <- c(
        "title",
        "purpose",
        "category",
        "officer_role",
        "officer_name",
        "officer_party")

    obs <- get_member_data()
    exp <- readRDS("data/get_officer_data.RData")
    compare_obs_exp(obs, exp, cols, "title")
})
