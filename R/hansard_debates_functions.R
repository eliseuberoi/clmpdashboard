#' Fetch data on how many debates MPs took part in
#'
#' \code{get_url} Generates url showing debates MP spoke in during a defined period
#'
#' @param mnis_id An MP's MNIS identification number
#' @param start_date The start date of the period of interest ("yyyy-mm-dd")
#' @param end_date The end date of the period of interest ("yyyy-mm-dd"), set to today as default
#' @return A tibble incuding an MP's MNIS number and their url
#' @keywords internal
#'

get_url <- function(mnis_id, start_date, end_date = Sys.Date()) {

  start <- "https://hansard.parliament.uk/search/MemberContributions?"
  mnis <- stringr::str_glue("memberId={mnis_id}")
  start_date <- stringr::str_glue("&startDate={start_date}")
  end_date <- stringr::str_glue("&endDate={end_date}")
  end <- "&type=Spoken&outputType=Group&partial=True"

  url <- paste0(start, mnis, start_date, end_date, end, collapse = ", ")

  tibble::tibble(MNIS_id = mnis_id,
                 url = url)
}

#' \code{get_number} Find the number of debates an MP spoke in
#'
#' @param url The url showing the number of debates
#' @param pb Generates a progress bar using the length of the vector of urls
#' @return A tibble incuding an MP's url and the total number of debates they spoke in
#' @keywords internal
#'

get_number <- function(url, pb){

  pb$tick()$print()

  html <- xml2::read_html(url)

  result <- html %>%
    rvest::html_node(".result-text") %>%
    rvest::html_text()

  digits <- stringr::str_extract_all(result, "\\d+")
  total_debates <- digits[[1]][1]

  tibble::tibble(url = url,
                 debates = total_debates)
}

#' \code{get_debates} Get the number of debates each Member spoke in during a defined period
#'
#' @param members A tibble with Member data, including a MNIS ID (constant given as default)
#' @param start_date The start date of the period of interest ("yyyy-mm-dd")
#' @param end_date The end date of the period of interest ("yyyy-mm-dd"), set to today as default
#' @return A tibble incuding for each current MP their url and the total number of debates they spoke in
#' @export
#'

get_debates <- function(members = MEMBERS, start_date, end_date = Sys.Date()) {

  urls <- purrr::map_dfr(members$MNIS_id, ~get_url(., start_date, end_date))
  pb <- dplyr::progress_estimated(length(urls$url))
  number_debates <- purrr::map_dfr(urls$url, ~get_number(., pb))
  member_debates <- dplyr::left_join(urls, number_debates)

  member_debates
}


