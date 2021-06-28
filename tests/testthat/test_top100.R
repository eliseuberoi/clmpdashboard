### Test functions in top100.R

# Imports ---------------------------------------------------------------------

source("validate.R")

# Tests -----------------------------------------------------------------------

test_that("get_top100 processes results correctly.", {

    cols <- c(
        "word",
        "n",
        "full_name",
        "MNIS_id",
        "display_name")

    contributions_data <- read("get_top100_mocks_data")

    obs <- get_top100(contributions_data)
    exp <- readRDS("data/get_top100_data.RData")
    compare_obs_exp(obs, exp, cols, "word")
})

#  test failing

