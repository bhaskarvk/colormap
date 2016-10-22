# Shamelessly adapted from https://github.com/sjmgarnier/viridis/blob/master/R/scales.R

#' Create a Palette generating function
#' @param alpha pass through parameter to \code{colormap}
#'
#' @param colormap pass through parameter to \code{colormap}
#'
#' @param reverse pass through parameter to \code{colormap}
#'
#' @examples
#' scales::show_col(colormap_pal()(10))
#' scales::show_col(colormap_pal(colormap=colormaps$viridis)(100), labels=FALSE)
#'
#' @return A function that can generate colors from a specified colormap.
#'
#' @export
colormap_pal <- function(alpha = 1, colormap = colormaps$viridis, reverse=FALSE) {
  function(n) {
    colormap(colormap=colormap, alpha = alpha,
             format='hex', reverse=reverse,
             nshades = n)
  }
}


#' @rdname scale_colormap
#'
#' @aliases scale_colour_colormap
#'
#' @export
scale_color_colormap <- function(..., alpha = 1, colormap = colormaps$viridis,
                                discrete = FALSE, reverse = FALSE) {

  if (discrete) {
    ggplot2::discrete_scale("colour", "colormap",
                            colormap_pal(alpha, colormap, reverse), ...)
  } else {
    # avoid duplicate colors of some palettes.
    ggplot2::scale_color_gradientn(
      colours = colormap(alpha = alpha, colormap = colormap, reverse = reverse,
                         format = 'hex', nshades = 256),
      ...)
  }
}

#' Colormap color scales
#'
#' Uses the colormap color scale
#'
#' For \code{discrete == FALSE} (the default) all other arguments are as to
#' \link[ggplot2]{scale_fill_gradientn} or \link[ggplot2]{scale_color_gradientn}.
#' Otherwise the function will return a \code{discrete_scale} with the plot-computed
#' number of colors.
#'
#' See \link[colormap]{colormap} for more information on the color scale.
#'
#' @param ... parameters to \code{discrete_scale} or \code{scale_fill_gradientn}
#'
#' @param alpha pass through parameter to \code{colormap}
#'
#' @param colormap pass through parameter to \code{colormap}
#'
#' @param reverse pass through parameter to \code{colormap}
#'
#' @param discrete generate a discrete palette? (default: \code{FALSE} - generate continuous palette)
#'
#' @rdname scale_colormap
#'
#' @export
scale_fill_colormap <- function(..., alpha = 1, colormap = colormaps$viridis,
                                discrete = FALSE, reverse = FALSE) {

  if (discrete) {
    ggplot2::discrete_scale("fill", "colormap",
                            colormap_pal(alpha, colormap, reverse), ...)
  } else {
    # avoid duplicate colors of some palettes.
    ggplot2::scale_fill_gradientn(
      colours = colormap(alpha = alpha, colormap = colormap, reverse = reverse,
                         format = 'hex', nshades = 256),
      ...)
  }
}
