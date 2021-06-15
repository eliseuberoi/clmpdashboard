#' Functions to join parliamentary search data with Member data using fuzzy matching
#'
#' \code{get_match_names} Creates a function to use fuzzy matching to find matches for Member names
#'
#' @param members A tibble with data on current Members (constant provided as default)
#' @param missing_name A vector of Member names in activity data that do not match names in Member data
#' @return A function to use fuzzy matching to find matches for Member names
#' @keywords internal
#'

get_match_names <- function(members = MEMBERS) {

  match_names <- function(missing_name) {

    mp_full_name <- members$full_name

    match <- agrep(pattern = missing_name, x = mp_full_name,
                   max.distance= c(all=2), value=TRUE)

    # Check there is only one name and remove otherwise
    if (length(match) == 0) { match <- NA }
    if (length(match) > 1) { match <- NA }

    tibble::tibble(
      missing_name = missing_name,
      match = match)
  }
}

#' \code{join_and_match} Joins parliamentary search data with Member data using fuzzy matching
#'
#' @param data A tibble with activity data from Parliamentary Search (may also work on other data)
#' @param members A tibble with data on current Members (constant provided as default)
#' @return A list including a tibble with activity data joined with Member data (joined_data) and a tibble showing names matched using fuzzy matching (matches)
#' @export

join_and_match <- function(data, members = MEMBERS) {

  joined_data <-
    dplyr::left_join(data,
                     members %>% dplyr::select(.data$MNIS_id, .data$gender,
                                               .data$constituency, .data$full_name))

  # Find cases where join has not worked because names do not match
  missing <- dplyr::filter(joined_data, is.na(.data$constituency))
  missing_names <- unique(missing$full_name)

  # Find approximate matches for missing names
  match_names <- get_match_names(members)
  matches <- purrr::map_dfr(missing_names, ~match_names(.))

  # Output both joined data and matches for missing names: these must be manually checked
  joined_and_matches <- list(joined_data = joined_data,
                          matches = matches)

  joined_and_matches
}

#' \code{rejoin_data} Takes output from the join_and_match function to correct errors in the initial join
#'
#' @param joined_data A tibble with activity data joined with Member data
#' @param matches A tibble showing names matched using fuzzy matching, corrected manually where needed
#' @param members A tibble with data on current Members (constant provided as default)
#' @return A tibble with activity data joined with Member data
#' @export

rejoin_data <- function(joined_data, matches, members = MEMBERS) {

  unjoined_data <- joined_data %>% dplyr::select(-c(.data$MNIS_id,
                                                    .data$gender, .data$constituency))

  pattern <- matches$missing_name
  replacement <- matches$match
  full_name <- unjoined_data$full_name

  for (i in 1:length(pattern)) {
    full_name <- stringr::str_replace_all(
      full_name,
      stringr::str_glue("^{pattern[i]}$"),
      replacement[i])
  }

  unjoined_data$full_name <- full_name

  # Join again
  joined_data <-
    dplyr::left_join(unjoined_data,
                     members %>% dplyr::select(.data$MNIS_id, .data$gender,
                                               .data$constituency, .data$full_name))
  joined_data
}


