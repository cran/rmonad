% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cache.R
\name{no_cache}
\alias{no_cache}
\title{Represent a value that has been deleted}
\usage{
no_cache()
}
\value{
A function that represents a deleted value
}
\description{
By default, the value of a node that has already been executed will be set
to this function.
}
\seealso{
Other cache: \code{\link{clear_cache}},
  \code{\link{fail_cache}}, \code{\link{make_cacher}},
  \code{\link{make_recacher}}, \code{\link{memory_cache}},
  \code{\link{void_cache}}
}
\concept{cache}
