#' Fetch data on the government and opposition posts MPs hold
#'
#' \code{get_gvt_posts} Downloads data on government posts
#'
#' @param members A tibble with Member data, including a MNIS ID (constant given as default)
#' @return A tibble showing the government roles MPs hold
#' @keywords Internal
#'

get_gvt_posts <- function(members = MEMBERS) {

  url_gvt <- stringr::str_c("https://data.parliament.uk/membersdataplatform/",
                            "services/mnis/members/query/house=Commons|",
                            "IsEligible=true|holdsgovernmentpost=true")

  # Download and process data on government posts
  request_gvt <- httr::GET(url = url_gvt)

  gvt_text <- request_gvt %>% httr::content(as = "text", encoding = "utf-8")

  gvt <- gvt_text %>%
    stringr::str_sub(1) %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    data.frame()

  # Select relevant columns only
  gvt <- gvt[, c(1,6)]

  # Create government role variable (all MPs in this set have a government role)
  gvt$gvt_role <- 1

  # Prepare for joining
  names(gvt)[1] <-"MNIS_id"
  gvt$MNIS_id <- as.numeric(gvt$MNIS_id)

 gvt

}

#' \code{get_opp_posts} Downloads data on opposition posts
#'
#' @param members A tibble with Member data, including a MNIS ID (constant given as default)
#' @return A tibble showing the opposition roles MPs hold
#' @keywords Internal
#'

get_opp_posts <- function(members = MEMBERS) {

  url_opp <- stringr::str_c("https://data.parliament.uk/membersdataplatform/",
                            "services/mnis/members/query/house=Commons|",
                            "IsEligible=true|holdsoppositionpost=true")

  # Download and process data on opposition posts
  request_opp <- httr::GET(url = url_opp)

  opp_text <- request_opp %>% httr::content(as = "text", encoding = "utf-8")

  opp <- opp_text %>%
    stringr::str_sub(1) %>%
    jsonlite::fromJSON(flatten = TRUE) %>%
    data.frame()

  # Select relevant columns only
  opp <- opp[, c(1,6)]

  # Create opposition role variable (all MPs in this set have an opposition role)
  opp$opp_role <- 1

  # Prepare for joining
  names(opp)[1] <-"MNIS_id"
  opp$MNIS_id <- as.numeric(opp$MNIS_id)

  opp

}

#' \code{get_posts} Downloads data on government and opposition posts
#'
#' @param members A tibble with Member data, including a MNIS ID (constant given as default)
#' @return A tibble showing the government and opposition roles MPs hold
#' @export
#'

get_posts <- function(members = MEMBERS) {

   gvt <- get_gvt_posts(members)
   opp <- get_opp_posts(members)

   roles <- dplyr::full_join(gvt[, c(1,3)], opp[, c(1,3)])
   members_roles <- dplyr::left_join(members, roles)

   members_roles
}






