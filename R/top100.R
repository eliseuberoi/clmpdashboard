#' Functions to identify the top 100 words spoken by individual MPs
#'
#' \code{get_STOPWORDS} Defines a list of stop words to remove before analysing contributions
#'
#' @param members A tibble with Member data (constant given as default)
#' @return A vector of stop words
#' @keywords internal
#'

get_STOPWORDS <- function(members = MEMBERS) {

    process_words <- function(words) {

        words %>% tibble::enframe(name = NULL) %>% dplyr::rename(word = .data$value)
    }

    parly_stop_words <- c(

        "hon",
        "government",
        "friend",
        "house",
        "debate",
        "time",
        "gentleman",
        "constituency",
        "constituents",
        "lady",
        "secretary",
        "government",
        "governments",
        "government's",
        "minister",
        "ministers",
        "minister's",
        "leader",
        "committee",
        "speaker",
        "prime minister",
        "speech",
        "questions",
        "question",
        "parliament",
        "commons",
        "lords",
        "chamber",
        "dr",
        "st",
        "agree",
        "ms",
        "sir",
        "dame",
        "office",
        "department",
        "intervention",
        "ago",
        "learned",
        "member"

    )

    party_stop_words <- c(

        "con",
        "lab",
        "ld",
        "snp",
        "dup",
        "pc",
        "ind",
        "conservative",
        "labour",
        "liberal",
        "democrat",
        "scottish",
        "national",
        "party",
        "democratic",
        "unionist",
        "plaid",
        "cymru",
        "sinn",
        "fein"

    )

    month_stop_words <- c(

        "january",
        "february",
        "march",
        "april",
        "may",
        "june",
        "july",
        "august",
        "september",
        "october",
        "november",
        "december"

    )

    mp_first_stop_words <- members$first_name
    mp_last_stop_words <- members$last_name

    stop_words <- list(parly_stop_words, party_stop_words, month_stop_words,
                       mp_first_stop_words, mp_last_stop_words)

    stopwords <- purrr::map_dfr(stop_words, ~process_words(.))

    stopwords$word <- tolower(stopwords$word)

    stopwords
}

#' \code{get_top100} Gets the 100 most spoken words for each MP
#' @param contributions_joined A tibble with data on Members' contributions (from parliamentary search), joined with Member data using this package's joining functions
#' @param members A tibble with Member data (constant given as default)
#' @return A tibble with each Member's 100 most used words
#' @export
#'

get_top100 <- function(contributions_joined, members = MEMBERS) {

    contributions_joined$edited <- contributions_joined$content %>% tm::removeNumbers()

    top100 <- purrr::map_dfr(members$full_name, function(MP_name) {

        member_data <- contributions_joined %>% dplyr::filter(.data$full_name == MP_name) %>%
            dplyr::select(.data$member, .data$edited) %>%
            tidytext::unnest_tokens(.data$word, .data$edited) %>% dplyr::select(.data$word) %>%
            dplyr::filter(!.data$word %in% STOPWORDS$word) %>%
            dplyr::filter(!.data$word %in% tidytext::stop_words$word) %>%
            dplyr::count(.data$word, sort = TRUE)

        # Get top 100 or all rows, whichever is smaller
        if (nrow(member_data) > 0) {

            last_row <- min(nrow(member_data), 100)
            member_data <- member_data[1:last_row,]
            member_data$full_name <- MP_name

        } else {

            tibble::tibble()
        }

        member_data
    })

    top100 <- dplyr::left_join(top100, members[,  c(1,2,10)])

    top100

}
