### Test functions in data_joining_functions.R

# Tests -----------------------------------------------------------------------

test_that("get_match_names produces names correctly.", {

    members <- readRDS("data/get_member_data.RData")
    match_names <- get_match_names()

    missing_names <- c("Abbot, Diane", "Hart, Sally-Ann", "Hayes, Jon", "Johnston, Kim")
    matches <- purrr::map_dfr(missing_names, ~match_names(.))

    expected <- dplyr::tibble(
        missing_name = c("Abbot, Diane", "Hart, Sally-Ann", "Hayes, Jon", "Johnston, Kim"),
        match = c("Abbott, Diane", NA, "Hayes, John", "Johnson, Kim")
    )

    expect_equal(matches, expected)

})


