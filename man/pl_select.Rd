% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/select.R
\name{pl_select}
\alias{pl_select}
\title{Select columns from a Data/LazyFrame}
\usage{
pl_select(data, ...)
}
\arguments{
\item{data}{A Polars Data/LazyFrame}

\item{...}{Any expression accepted by `dplyr::select()`: variable names,
column numbers, select helpers, etc.}
}
\description{
Select columns from a Data/LazyFrame
}
\examples{

pl_iris <- polars::pl$DataFrame(iris)

pl_select(pl_iris, c("Sepal.Length", "Sepal.Width"))
pl_select(pl_iris, Sepal.Length, Sepal.Width)
pl_select(pl_iris, 1:3)
pl_select(pl_iris, starts_with("Sepal"))
pl_select(pl_iris, -ends_with("Length"))
}
