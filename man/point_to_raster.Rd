% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/point_to_raster.R
\name{point_to_raster}
\alias{point_to_raster}
\title{Convert outlet of a watershed from shapefile format into raster format}
\usage{
point_to_raster(outlets, out, overwrite = FALSE)
}
\arguments{
\item{outlets}{A shapefile of outlets in the current GRASS mapset.}

\item{out}{The name of the output raster.}

\item{overwrite}{A logical indicating whether the output should be allowed to overwrite existing files. Defaults to \code{FALSE}.}
}
\value{
Nothing. A file called \code{out} will be created in the current GRASS mapset.
}
\description{
Given a shapefile of outlet(s), this function will convert its contents into a raster.
}