#' Download data by division
#'
#' \code{get_division} Downloads raw data on division
#'
#' @param division_id The unique ID of the division to download
#' @return A tibble containing data on a division
#' @keywords internal
#'
get_division <- function(division_id) {

    path <- "https://commonsvotes-services.digiminster.com/data/division/"

    request <- httr::GET(url = paste0(path, division_id, ".json", collapse = ", "))

    division <- request %>% httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

    division
}

#' Find all divisions and their IDs within a date range
#'
#' \code{get_div_ids} Gets division IDs for all divisions in date range
#'
#' @param start_date The start date of the period of interest ("yyyy-mm-dd")
#' @param end_date The end date of the period of interest ("yyyy-mm-dd")
#' @return A vector containing division IDs
#' @keywords internal
#'
get_div_ids <- function(start_date, end_date) {

    url <- paste0("https://commonsvotes-services.digiminster.com/data/divisions.json/groupedbyparty?queryParameters.startDate=",
            start_date, "&queryParameters.endDate=", end_date, collapse = ", ")

    request <- httr::GET(url)

    result <- request %>% httr::content(as = "text", encoding = "UTF-8") %>%
        jsonlite::fromJSON(flatten = TRUE)

    div_ids <- result$DivisionId

}

#' Process division data
#'
#' \code{process_division} Processes raw division data to show votes by MP
#'
#' @param division Raw data for the division of interest
#' @return A tibble showing for a division all MPs voting Aye and No, all MPs who did not vote and all Tellers
#' @keywords internal
#'
process_division <- function(division){

    a <- tibble::tibble()

    if (length(division$Ayes) > 0) {
        Ayes <- division$Ayes

        a <- tibble::tibble(
            DivisionId = division$DivisionId,
            Date = division$Date,
            Title = division$Title,
            AyeCount = division$AyeCount,
            NoCount = division$NoCount,
            MemberId = Ayes$MemberId,
            MemberName = Ayes$Name,
            MemberParty = Ayes$Party,
            Aye = 1,
            No = 0,
            NoVoteRecorded = 0,
            TellerAye = 0,
            TellerNo = 0)
    }

    n <- tibble::tibble()

    if (length(division$Noes) > 0) {
        Noes <- division$Noes

        n <- tibble::tibble(
            DivisionId = division$DivisionId,
            Date = division$Date,
            Title = division$Title,
            AyeCount = division$AyeCount,
            NoCount = division$NoCount,
            MemberId = Noes$MemberId,
            MemberName = Noes$Name,
            MemberParty = Noes$Party,
            Aye = 0,
            No = 1,
            NoVoteRecorded = 0,
            TellerAye = 0,
            TellerNo = 0)
    }

    nvr <- tibble::tibble()

    if (length(division$NoVoteRecorded) > 0) {
        NoVoteRecorded <- division$NoVoteRecorded

        nvr <- tibble::tibble(
            DivisionId = division$DivisionId,
            Date = division$Date,
            Title = division$Title,
            AyeCount = division$AyeCount,
            NoCount = division$NoCount,
            MemberId = NoVoteRecorded$MemberId,
            MemberName = NoVoteRecorded$Name,
            MemberParty = NoVoteRecorded$Party,
            Aye = 0,
            No = 0,
            NoVoteRecorded = 1,
            TellerAye = 0,
            TellerNo = 0)
    }

    AT <- tibble::tibble()

    if (length(division$AyeTellers) > 0) {
        AyeTellers <- division$AyeTellers

        AT <- tibble::tibble(
            DivisionId = division$DivisionId,
            Date = division$Date,
            Title = division$Title,
            AyeCount = division$AyeCount,
            NoCount = division$NoCount,
            MemberId = AyeTellers$MemberId,
            MemberName = AyeTellers$Name,
            MemberParty = AyeTellers$Party,
            Aye = 0,
            No = 0,
            NoVoteRecorded = 0,
            TellerAye = 1,
            TellerNo = 0)
    }

    NT <- tibble::tibble()

    if (length(division$NoTellers) > 0) {
        NoTellers <- division$NoTellers

        NT <- tibble::tibble(
            DivisionId = division$DivisionId,
            Date = division$Date,
            Title = division$Title,
            AyeCount = division$AyeCount,
            NoCount = division$NoCount,
            MemberId = NoTellers$MemberId,
            MemberName = NoTellers$Name,
            MemberParty = NoTellers$Party,
            Aye = 0,
            No = 0,
            NoVoteRecorded = 0,
            TellerAye = 0,
            TellerNo = 1)
    }

    dplyr::bind_rows(a, n, nvr, AT, NT)
}

#' Download and process division data
#'
#' \code{get_divisions_data} Downloads and processes division data to show votes by MP
#'
#' @param start_date The start date of the period of interest ("yyyy-mm-dd")
#' @param end_date The end date of the period of interest ("yyyy-mm-dd")
#' @return A tibble showing for all MPs voting Aye and No, all MPs who did not vote and all Tellers for all divisions within a date range
#' @export
#'
get_divisions_data <- function(start_date, end_date) {
    div_ids <- get_div_ids(start_date, end_date)
    divisions <- purrr::map(div_ids, ~ get_division(.))
    divisions_record <- purrr::map_dfr(divisions, ~process_division(.))
}


