### Test functions in get_full_name.R

# Tests -----------------------------------------------------------------------

test_that("get_full_name produces names correctly.", {

    names <- c("Abbott, Diane", "Abrahams, Debbie", "Adams, Nigel", "Afolami, Bim", "Afriyie, Adam", "Hart, Sally-Ann", "Trevelyan, Anne-Marie")
    full_names <- get_full_name(names)

    expected <- c("Abbott, Diane", "Abrahams, Debbie", "Adams, Nigel", "Afolami, Bim", "Afriyie, Adam", "Hart, Sally", "Trevelyan, Anne")

    expect_equal(full_names, expected)

})


