#' @title Centroid of a set of coordinates
#' 
#' @description This function computes the centroid of a set of x-y (or 
#'  longitude-latitude) coordinates. 
#' 
#' @param x A vector of x (or longitude) coordinates.
#' 
#' @param y A vector of y (or latitude) coordinates.
#' 
#' @param geo A logical value indicating whether the locations are defined by 
#'  geographic coordinates (pairs of longitude/latitude values). Default: FALSE.
#' 
#' @return A two-element vector corresponding to the location of the centroid.
#' 
#' @author Simon Garnier, \email{garnier@@njit.edu}
#' 
#' @seealso \code{\link{dist2centroid}}
#' 
#' @examples
#' # TODO
#' 
#' @export
centroid <- function(x, y, geo = FALSE) {
  if (!is.vector(x) || !is.vector(y) || length(x) != length(y)) {
    stop("x and y must be vector of identical length.")
  }
  
  if (geo) {
    if (length(x) > 1) {
      centrd <- data.table::as.data.table(geosphere::geomean(cbind(x, y)))
      names(centrd) <- c("lon", "lat")
    } else {
      centrd <- data.table::data.table(lon = x, lat = y)
    }
  } else {
    centrd <- data.table::data.table(x = mean(x, na.rm = TRUE), 
                                     y = mean(y, na.rm = TRUE))
  }
  
  centrd
}

#' @title Distance to the centroid of a set of coordinates
#' 
#' @description Given a set of x-y (or longitude-latitude) coordinates, this 
#'  function computes their distance to the centroid of the set.
#' 
#' @param x A vector of x (or longitude) coordinates.
#' 
#' @param y A vector of y (or latitude) coordinates.
#' 
#' @param geo A logical value indicating whether the locations are defined by 
#'  geographic coordinates (pairs of longitude/latitude values). Default: FALSE.
#' 
#' @return A vector of the same length as x and y corresponding to the 
#'  individual distance of each point to the centroid of the set.
#' 
#' @author Simon Garnier, \email{garnier@@njit.edu}
#'  
#' @examples
#' # TODO
#' 
#' @export
dist2centroid <- function(x, y, geo = FALSE) {
  if (!is.vector(x) || !is.vector(y) || length(x) != length(y)) {
    stop("x and y must be vector of identical length.")
  }
  
  centrd <- as.matrix(centroid(x, y, geo = geo))
  
  if (geo) {
    m1 <- matrix(centrd, nrow = length(x), ncol = 2, byrow = TRUE)
    m2 <- cbind(x, y)
    geosphere::distGeo(m1, m2)
  } else {
    sqrt((x - centrd[1]) ^ 2 + (y - centrd[2]) ^ 2)
  }
}
