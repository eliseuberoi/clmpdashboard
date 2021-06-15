### Test functions in edms_functions.R

# Imports ---------------------------------------------------------------------

source("validate.R")

# Mocks -----------------------------------------------------------------------

mock_httr_get_list <- function(url) {
    read("get_edms_list_mocks_data")
}

mock_httr_get_signatures <- function(url) {
    read("get_edms_signatures_mocks_data")
}

# Tests -----------------------------------------------------------------------

test_that("get_edms_list processes results correctly.", {

    mockery::stub(get_edms_list, "httr::GET", mock_httr_get_list)

    cols <- c(
        "Id",
        "Status",
        "StatusDate",
        "MemberId",
        "Title",
        "MotionText",
        "AmendmentToMotionId",
        "UIN",
        "AmendmentSuffix",
        "DateTabled",
        "PrayingAgainstNegativeStatutoryInstrumentId",
        "StatutoryInstrumentNumber",
        "StatutoryInstrumentYear",
        "StatutoryInstrumentTitle",
        "UINWithAmendmentSuffix",
        "SponsorsCount",
        "PrimarySponsor.MnisId",
        "PrimarySponsor.PimsId",
        "PrimarySponsor.Name",
        "PrimarySponsor.ListAs",
        "PrimarySponsor.Constituency",
        "PrimarySponsor.Status",
        "PrimarySponsor.Party",
        "PrimarySponsor.PartyId",
        "PrimarySponsor.PartyColour",
        "PrimarySponsor.PhotoUrl")

    obs <- get_edms_list("2020-03-01", "2020-03-29")
    exp <- readRDS("data/get_edms_list_data.RData")
    compare_obs_exp(obs, exp, cols, "Id")
})

test_that("get_edms_signatures processes results correctly.", {

    mockery::stub(get_edms_signatures, "httr::GET", mock_httr_get_signatures)

    cols <- c(
        "Id",
        "MemberId",
        "SponsoringOrder",
        "CreatedWhen",
        "IsWithdrawn",
        "WithdrawnDate",
        "Member.MnisId",
        "Member.PimsId",
        "Member.Name",
        "Member.ListAs",
        "Member.Constituency",
        "Member.Status",
        "Member.Party",
        "Member.PartyId",
        "Member.PartyColour",
        "Member.PhotoUrl",
        "edm_id",
        "primary_sponsor")

    obs <- get_edms_signatures(56795)
    exp <- readRDS("data/get_edms_signatures_data.RData")
    compare_obs_exp(obs, exp, cols, "Id")
})
