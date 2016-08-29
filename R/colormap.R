
#' List of pre-defined colormaps
#' @export
colormaps <- list(
    jet='jet',
    hsv='hsv',
    hot='hot',
    cool='cool',
    spring='spring',
    summer='summer',
    autumn='autumn',
    winter='winter',
    bone='bone',
    copper='copper',
    greys='greys',
    YIGnBu='YIGnBu',
    greens='greens',
    YIOrRd='YIOrRd',
    bluered='bluered',
    RdBu='RdBu',
    picnic='picnic',
    rainbow='rainbow',
    portland='portland',
    blackbody='blackbody',
    earth='earth',
    electric='electric',
    viridis='viridis',
    inferno='inferno',
    magma='magma',
    plasma='plasma',
    warm='warm',
    cool='cool',
    rainbow_soft='rainbow-soft',
    bathymetry='bathymetry',
    cdom='cdom',
    chlorophyll='chlorophyll',
    density='density',
    freesurface_blue='freesurface-blue',
    freesurface_red='freesurface-red',
    oxygen='oxygen',
    par='par',
    phase='phase',
    salinity='salinity',
    temperature='temperature',
    turbidity='turbidity',
    velocity_blue='velocity-blue',
    velocity_green='velocity-green',
    cubehelix='cubehelix'
)

#' Generate colors from a list of 44 palettes
#'
#' @export
#' @param colormap A string.
#' You can use the colormaps list for a list of pre-defined palettes
#' @param nshades A number.
#' Number of colors to generate.
#' Certain palettes require a minimum number and the function will
#' throw an error if this value is less than that.
#' @param format. A string.
#' Should be 'hex', 'rgb', or 'rgbaString'
#' @param alpha. A Number of Vector
#' A single float between 0 and 1, or a vector with two elements, each between 0 and 1.
#'
#' @return Colors either in vector, matrix, list format depending on format.
#' @examples
#' colormap() # Defaults to 72 colors from the 'jet' palette.
#' colormap(colormap=colormaps$temperature, nshades=20) # Diff Palette
#' colormap(format='rgb',nshades=10) # As rgb
#' colormap(format='rgb',nshades=10,alpha=0.5) # Constant alpha
#' colormap(format='rgb',nshades=10,alpha=c(0.2,08)) # Alpha Range
#' colormap(format='rgbaString',nshades=10) # As rgba string
colormap <- function(colormap=colormaps$jet, nshades=72,
                     format='hex', alpha=1) {
  ct$call('colormap',list(colormap=colormap,nshades=nshades,
                          format=format,alpha=alpha))
}

.onAttach <- function(libname, pkgname) {
  ct <<- V8::new_context()
  ct$source(system.file("js/colormap.js", package="colormap"))

}