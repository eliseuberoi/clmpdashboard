% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_joining_functions.R
\name{rejoin_data}
\alias{rejoin_data}
\title{\code{rejoin_data} Takes output from the join_and_match function to correct errors in the initial join}
\usage{
rejoin_data(joined_data, matches, members = MEMBERS)
}
\arguments{
\item{joined_data}{A tibble with activity data joined with Member data}

\item{matches}{A tibble showing names matched using fuzzy matching, corrected manually where needed}

\item{members}{A tibble with data on current Members (constant provided as default)}
}
\value{
A tibble with activity data joined with Member data
}
\description{
\code{rejoin_data} Takes output from the join_and_match function to correct errors in the initial join
}
