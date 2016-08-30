# Helper Function to sample n values from 1:N distributed evenly.
# e.g.
# getIndexes(255,3) = c(1,128,255)
# getIndexes(255,5) = c(1,64,128,192,255)
getIndexes <- function(N,n) {
  if(N< n) {
    stop("n should be < N")
  }

  # shortcut for n=1|2|N
  if(n==1) {
    c(N)
  } else if(n==2) {
    c(1,N)
  } else if(n==N) {
    1:N
  } else {
    c(1, ceiling(1:(n-2)*N/(n-1)) ,N)
  }
}

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
#' @param format A string.
#' Should be 'hex', 'rgb', or 'rgbaString'
#' @param alpha A Number between 0 and 1
#' @param reverse Boolean. Whether to reverse the order.
#'
#' @return Colors either in vector, matrix, list format depending on format.
#' @examples
#' colormap() # Defaults to 72 colors from the 'jet' palette.
#' colormap(colormap=colormaps$temperature, nshades=20) # Diff Palette
#' colormap(format='rgb',nshades=10) # As rgb
#' colormap(format='rgb',nshades=10,alpha=0.5) # Constant alpha
#' colormap(format='rgbaString',nshades=10) # As rgba string
colormap <- function(colormap=colormaps$jet, nshades=72,
                     format='hex', alpha=1, reverse=FALSE) {

  # validate inputs
  if(! (colormap %in% colormaps )) {
    stop(sprintf("Unrecognised colormap: '%s'.\n See the colormap::colormaps for a list of allowed colormaps",
         colormap))
  }

  if(!(is.numeric(alpha) && alpha >=0 && alpha <= 1)) {
    stop("alpha needs to be a number between 0 and 1")
  }

  if(!(format %in% c('hex', 'rgb', 'rgbaString'))) {
    stop("format should be one of 'hex', 'rgb', 'rgbaString'")
  }

  if(!is.numeric(nshades)) {
    stop("nshades needs to be a number")
  }

  # Ideally I would like to avoid this check.
  # But having this allows one to directly call colormaps::colormap()
  # w/o having to attach the package.
  if(!exists("ct", globalenv())) {
    ct <<- V8::new_context()
    ct$source(system.file("js/colormap.js", package="colormap"))
  }

  # The Javascript lib doesn't do a good job picking out a small number of colors.
  # So we generate a large number of colors and sample accordingly.
  # this ensures a evenly distributed color palette over the entire range.
  minshades <- max(nshades,256)

  # Over to V8 + colormap JS.
  val <- ct$call('colormap',list(colormap=colormap,nshades=minshades,
                                 format=format,alpha=alpha))

  #Pick only required number of colors
  if(nshades<minshades){
    val <- switch(format,
                  "hex" = val[getIndexes(minshades, nshades)],
                  "rgb" = val[getIndexes(minshades, nshades),],
                  "rgbaString" = val[getIndexes(minshades, nshades)])
  }

  # for hex format add Alpha to the end of each color bcoz the JS function doesn't.
  if(format=='hex') {
    val <- stringr::str_c(val ,as.character.hexmode(255*alpha))
  }

  if(reverse) {
    rev(val)
  } else {
    val
  }

}

.onAttach <- function(libname, pkgname) {
  ct <<- V8::new_context()
  ct$source(system.file("js/colormap.js", package="colormap"))

}