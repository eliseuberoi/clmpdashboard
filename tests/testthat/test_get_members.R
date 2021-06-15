### Test functions in get_members.R

# Imports ---------------------------------------------------------------------

source("validate.R")

# Mocks -----------------------------------------------------------------------

mock_httr_get <- function(url) {
    read("get_member_data_mocks_data")
}

# Tests -----------------------------------------------------------------------

test_that("get_member_data processes results correctly.", {

    mockery::stub(get_member_data, "httr::GET", mock_httr_get)

    cols <- c(
        "MNIS_id",
        "display_name",
        "name",
        "gender",
        "start_date",
        "constituency",
        "party")

    obs <- get_member_data()
    exp <- readRDS("data/get_member_data.RData")
    compare_obs_exp(obs, exp, cols, "MNIS_id")
})
