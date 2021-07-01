#' \code{get_full_name} Creates new name variable to enable joining Parliamentary search data with Member data
#'
#' @param names A vector with Members' names (in activity data from Parliamentary Search)
#' @return A 'full name' vector with Members' names in standardised format
#' @export
#'

get_full_name <- function(names) {

  split_names <- stringr::str_split_fixed(names, ", ", n = Inf)
  first_name <- stringr::str_extract(split_names[,2], "(\\w+)")
  last_name <- split_names[,1]
  full_name <- paste(last_name, first_name, sep = ", ")

}
