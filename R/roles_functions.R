#' Fetch data on the government and opposition posts MPs hold
#'
#' \code{get_posts} Downloads data on government and opposition posts
#'
#' @param members A tibble with Member data, including a MNIS ID (constant given as default)
#' @return A tibble showing the government and opposition roles MPs hold
#' @export
#'

get_posts <- function(members = MEMBERS) {

    url_gov <- stringr::str_c("https://data.parliament.uk/membersdataplatform/",
                              "services/mnis/members/query/house=Commons|",
                              "IsEligible=true|holdsgovernmentpost=true")

    # Download and process data on government posts
    request_gov <- httr::GET(url = url_gov)

    gvt_text <- request_gov %>% httr::content(as = "text", encoding = "utf-8")

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

    roles <- dplyr::full_join(gvt[, c(1,3)], opp[, c(1,3)])

    members_roles <- dplyr::left_join(members, roles)

    members_roles
}






