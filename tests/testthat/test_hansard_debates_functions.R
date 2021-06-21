### Test functions in hansard_debates_functions.R

# Tests -----------------------------------------------------------------------

test_that("get_debates downloads and processes results correctly.", {

    members <- readRDS("data/get_member_data.RData")
    member_debates <- get_debates(members[1:10,], start_date = "2021-05-10", end_date = "2021-06-15")

    expected <- c(3,9,12,1,1,3,6,8,4,4)

    expect_equal(as.double(member_debates$debates), expected)

})
