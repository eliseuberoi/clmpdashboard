#' clmpdashboard: Join activity data with Member data
#'
#' @description Package for joining data on Members and their activities
#' @docType package
#' @name clmpdashboard
#' @importFrom magrittr %>%
#' @importFrom rlang .data
NULL

# Tell R CMD check about new operators
if(getRversion() >= "2.15.1") {
    utils::globalVariables(c(".", ":="))
}
