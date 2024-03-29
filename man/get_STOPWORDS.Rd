% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/top100.R
\name{get_STOPWORDS}
\alias{get_STOPWORDS}
\title{Functions to identify the top 100 words spoken by individual MPs}
\usage{
get_STOPWORDS(members = MEMBERS)
}
\arguments{
\item{members}{A tibble with Member data (constant given as default)}
}
\value{
A vector of stop words
}
\description{
\code{get_STOPWORDS} Defines a list of stop words to remove before analysing contributions
}
\keyword{internal}
