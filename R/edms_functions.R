#' Fetch and manipulate data on EDMs signed by Members
#'
#' \code{get_edms_list} Downloads a list of all EDMs signed in a period comprising whole weeks
#'
#' @param start_date The start date of the period of interest ("yyyy-mm-dd")
#' @param end_date The end date of the period of interest ("yyyy-mm-dd")
#' @return A tibble containing data on EDMs and their IDs
#' @keywords internal

get_edms_list <- function(start_date, end_date) {

  # Downloads are limited to 100 per call so this needs to be done by week
  generate_dates <- function(start_date, end_date) {

    start_date <- as.Date(start_date)
    end_date <- as.Date(end_date)

    week_starts <- seq(start_date, end_date, by = "week")
    week_ends <- seq(start_date, end_date, by = "week") - 1
    week_ends[length(week_ends)] <- week_starts[length(week_starts)]
    week_starts <- week_starts[-length(week_starts)]
    week_ends <- week_ends[-1]

    if (week_ends[length(week_ends)] != end_date) warning("Final days of period not included in data. Consider using a later end_date")

    list(
      week_starts = week_starts,
      week_ends = week_ends
    )
  }

  dates <- generate_dates(start_date, end_date)

  get_data <- purrr::map2_dfr(dates$week_starts, dates$week_ends, function(.x, .y) {

      url <- paste0("https://oralquestionsandmotions-api.parliament.uk/EarlyDayMotions/list?parameters.tabledStartDate=",
                    .x, "&parameters.tabledEndDate=", .y,
                    "&parameters.statuses=Published&parameters.take=100", collapse = ", ")

      request <- httr::GET(url)

      # Parse the response
      response <- request %>%
       httr::content(as = "text") %>%
       jsonlite::fromJSON(flatten = TRUE)

      # Extract the data frame
      data <- response$Response })

}

#' \code{get_edms_signatures} Gets all signatures for a given EDM
#'
#' @param id The unique identifier for an EDM
#' @return A tibble containing data on signatures and the primary sponsor of an EDM
#' @keywords internal
#'

get_edms_signatures <- function(id) {

  url <- paste0("https://oralquestionsandmotions-api.parliament.uk/EarlyDayMotion/",
                id, collapse =  ", ")

  request <- httr::GET(url)

  # Parse the response
  response <- request %>%
    httr::content(as = "text") %>%
    jsonlite::fromJSON(flatten = TRUE)

  # Extract the signatures data frame
  signature_data <- response$Response$Sponsors

  # Add in the EDM's identifier
  signature_data$edm_id <- id

  # Identify primary sponsor
  signature_data$primary_sponsor <- signature_data$Member.Name[1]

  signature_data
}

#' \code{fetch_edm_data} Download and process data on EDMs including signatures
#'
#' @param start_date The start date of the period of interest ("yyyy-mm-dd")
#' @param end_date The end date of the period of interest ("yyyy-mm-dd")
#' @return A tibble containing data on signatures and the primary sponsor of an EDM
#' @export
#'

fetch_edm_data <- function(start_date, end_date) {

  # Get EDM signature data
  edms <- get_edms_list(start_date, end_date)
  edms_signatures <- purrr::map_dfr(edms$Id, ~get_edms_signatures(.))

  # Select only relevant variables & clean
  edms_signatures <- edms_signatures %>% dplyr::select(.data$MemberId, .data$SponsoringOrder,
                                                       .data$IsWithdrawn, .data$edm_id,
                                                       .data$Member.Name, .data$primary_sponsor)
  edms_signatures <- dplyr::rename(edms_signatures, MNIS_id = .data$MemberId)
  edms <- dplyr::rename(edms, edm_id = .data$Id,
                        type = .data$PrayingAgainstNegativeStatutoryInstrumentId)
  edms_signatures <- dplyr::left_join(edms_signatures, edms %>%
                                 dplyr::select(.data$edm_id, .data$Title, .data$type))
  # Process prayer data
  edms_signatures$type <- ifelse(is.na(edms_signatures$type),
                                 "Early Day Motion", "Prayer")

  edms_signatures

}











