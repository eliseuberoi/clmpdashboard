### Test functions in divisions_functions.R

# Imports ---------------------------------------------------------------------

source("validate.R")

# Mocks -----------------------------------------------------------------------

mock_httr_get <- function(url) {
    read("get_division_mocks_data")
}

# Tests -----------------------------------------------------------------------

test_that("get_divisions_data processes results correctly.", {

    mockery::stub(get_divisions_data, "httr::GET", mock_httr_get, depth = 2)

    cols <- c(
        "DivisionId",
        "Date",
        "Title",
        "AyeCount",
        "NoCount",
        "MemberId",
        "MemberName",
        "MemberParty",
        "Aye",
        "No",
        "NoVoteRecorded",
        "TellerAye",
        "TellerNo")

    obs <- get_divisions_data("2019-12-20", "2019-12-20")
    exp <- readRDS("data/get_divisions_data.RData")
    compare_obs_exp(obs, exp, cols, "DivisionId")
})
