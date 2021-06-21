#' Fetch and manipulate data on APPG officers
#'
#' \code{get_officer_data} Downloads data on MPs holding roles in APPGs
#'
#' @param date The date of the register to download ("yyyy-mm-dd")
#' @param mp_noble_names A vector of names whose beginning equals a noble title, e.g. "Earl Jones"
#' @return A tibble containing data on APPGs and their officers
#' @keywords internal
#'

get_officer_data <- function(date, mp_noble_names = c()) {

  get_officers <- function(register_date) {
    parlygroups::download_appg(register_date)
    officers <- parlygroups::appg_officers()
    }

  officers <- get_officers(register_date = date)

  # Keep back any MPs whose name as written starts with a noble title e.g. "Earl Jones"
  mp_nobles <- officers %>% dplyr::filter(.data$officer_name %in% mp_noble_names)

  # Take out APPG officers who are peers
  remove_peers <- paste(NOBLE_TITLES, collapse = '|')
  officers <- officers %>%
    dplyr::filter(!stringr::str_detect(.data$officer_name, remove_peers))

  if (length(mp_nobles) > 0) {
    officers <- dplyr::bind_rows(officers, mp_nobles)
  }

  officers

}

#' \code{get_appg_full_name} Creates new name variable to enable joining with Member data
#'
#' @param officers A tibble with data on APPGs and their officers
#' @return A tibble incuding the above plus a new name variable
#' @keywords internal
#'

get_appg_full_name <- function(officers) {

  titles <- MP_TITLES
  officer_names <- officers$officer_name
  officer_names <- stringr::str_replace_all(officer_names,
                        pattern = paste(titles, collapse = "|"),
                        replacement = "") %>%
                        stringr::str_split_fixed(" ", n=Inf)

  # Check how many dimensions
  if (dim(officer_names)[2] > 3) stop("There are more than three name dimensions")

  officer_names <- tibble::tibble(first = officer_names[, 1],
                   second = officer_names[, 2],
                   third = officer_names[, 3])

  officers$full_name <- purrr::pmap_chr(officer_names, function(first, second, third) {
    first_name <- first
    last_name <- ""
    if (third != "") {
      last_name <- third
    } else {
      last_name <- second
    }
    paste0(last_name, ", ", first_name)
  })

  officers

}

#' \code{fetch_appg_officers} Downloads data on APPG officers and generates new name variable
#'
#' @param date The date of the register to download ("yyyy-mm-dd")
#' @param mp_noble_names A vector of names whose beginning equals a noble title, e.g. "Earl Jones"
#' @return A tibble incuding data on APPGs, their officers and names for joining with other data
#' @export
#'

fetch_appg_officers <- function(date, mp_noble_names = c()) {

  officers <- get_officer_data(date, mp_noble_names)
  officers <- get_appg_full_name(officers)

  officers

}
