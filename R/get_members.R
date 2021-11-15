#' Functions to download data on Members from MNIS
#'
#' \code{get_member_data} Downloads Member data from MNIS
#'
#' @return A tibble with data on current Members
#' @keywords internal
#'

get_member_data <- function() {

  path <- stringr::str_c(
    "http://data.parliament.uk/membersdataplatform/services/",
    "mnis/members/query/house=Commons|IsEligible=true")

  request <- httr::GET(url = path)

  # Get rid of the byte-order mark warning
  members_text <- request %>% httr::content(as = "text", encoding = "utf-8")

  members <- members_text %>%
    stringr::str_sub(1) %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    data.frame() %>%
    tibble::as_tibble()

  # Select relevant variables
  members <- members[, c(1, 5, 6, 9, 12, 11, 18)]
  colnames(members) <- c("MNIS_id", "display_name", "name", "gender",
                         "start_date", "constituency",  "party")

  members$MNIS_id <- as.numeric(members$MNIS_id)

  members
}

#' \code{get_member_full_name} Standardises Members' names for joining with other data
#'
#' @param members A tibble with data on current Members
#' @return A tibble with data on current Members, including a vector with standardised names
#' @keywords internal
#'

get_member_full_name <- function(members) {

  names <- stringr::str_split_fixed(members$name, ", ", n=Inf)
  y <- names[, 2]
  y <- stringr:: str_replace_all(
    y,
    pattern = paste(MP_TITLES, collapse = "|"),
    replacement = "")

  members$first_name <- stringr::str_extract(y, "(\\w+)")
  members$last_name <- names[,1]
  members$full_name <- paste(members$last_name, members$first_name,
                                 sep = ", ")

  members
}

#' \code{get_members} Downloads and manipulates data on current Members
#'
#' @return A tibble with data on current Members, including a vector with standardised names
#' @export
#'

get_members <- function() {

  members <- get_member_data() %>% get_member_full_name()

  party_short <- dplyr::tibble(party = c("Labour", "Conservative",
                                         "Labour (Co-op)",
                                         "Scottish National Party",
                                         "Sinn Féin", "Democratic Unionist Party",
                                         "Liberal Democrat",
                                         "Social Democratic & Labour Party",
                                         "Independent", "Alliance", "Speaker",
                                         "Plaid Cymru", "Green Party", "Alba Party"),
                               party_short = c("Lab", "Con", "Lab", "SNP",
                                               "SF", "DUP", "LD", "SDLP", "Ind",
                                              "All", "Spk", "PC", "Green", "Alba"))

  members <- dplyr::left_join(members, party_short)

  members
}
