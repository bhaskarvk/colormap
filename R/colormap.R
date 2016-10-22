ct <- NULL # This will be our V8 context

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
#' @param colormap A string, vector of hex color codes, or a list.
#' Use the \code{\link{colormaps}} for a list of pre-defined palettes.
#' OR
#' A vector of colors in hex e.g. \code{c('#000000','#777777','#FFFFFF')}
#' OR
#' A list of list e.g. \code{list(list(index=0,rgb=c(255,255,255)),list(index=1,rgb=c(255,0,0)))}
#' The index should go from 0 to 1. see \url{https://www.npmjs.com/package/colormap#options}
#' @param nshades A number.
#' Number of colors to generate.
#' @param format A string.
#' Should be 'hex', 'rgb', or 'rgbaString'
#' @param alpha A Number between 0 and 1
#' @param reverse Boolean. Whether to reverse the order.
#'
#' @return Colors either in vector, matrix, list format depending on format.
#' @examples
#' colormap() # Defaults to 72 colors from the 'viridis' palette.
#' colormap(colormap=colormaps$temperature, nshades=20) # Diff Palette
#' colormap(colormap=c('#000000','#FF0000'), nshades=20) # Colormap as vector of colors
#' # list of list. Maximum flexibility
#' colormap(colormap=list(list(index=0,rgb=c(0,0,0)),list(index=1,rgb=c(255,255,255))), nshades=10)
#' colormap(format='rgb',nshades=10) # As rgb
#' colormap(format='rgb',nshades=10,alpha=0.5) # Constant alpha
#' colormap(format='rgbaString',nshades=10) # As rgba string
colormap <- function(colormap=colormaps$viridis, nshades=72,
                     format='hex', alpha=1, reverse=FALSE) {

  # validate inputs
  if(inherits(colormap,'character')) {
    if(length(colormap)==1 && ! (colormap %in% colormaps) ) {
      stop(sprintf("Unrecognised colormap: '%s'.\n See the colormap::colormaps for a list of allowed colormaps",
           colormap))
    } else if(length(colormap)>1 && !(all(grepl('^#[0-9a-f]{6}$',colormap,
                                                ignore.case = T)))) {
    stop("colormap parameter should be a single string from the colormap::colormaps list or a vector of strings in HEX color format\n e.g. colormap='viridis' or colormap=c('#FCFDA1','#FF0033')")
    }
  } else if(!inherits(colormap,'list')) {
    stop("colormap parameter should be a single string from the colormap::colormaps list or a vector of strings in HEX color format\n e.g. colormap='viridis' or colormap=c('#FCFDA1','#FF0033') or a list of lists e.g. colormap=list(list(index=0,rgb=c(0,0,0)),list(index=1,rgb=c(255,255,255)))")
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

  # If colormap is a vector of hex strings, convert it to a format that the function expects
  if(inherits(colormap,'character') && length(colormap)>1) {
    cols <- unlist(apply(col2rgb(sort(colormap)),2,
                         function(x)list(rgb=c(x[[1]],x[[2]],x[[3]]))),
                   recursive = F)
    colIndx <- c(0,(getIndexes(100,length(colormap))/100)[-1])
    colormap <- mapply(function(a,b)list(index=a,rgb=b),colIndx,cols,
                       SIMPLIFY = F)
  }

  initV8()

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

initV8 <- function() {
  if(is.null(ct)) {
    ct <<- V8::v8()
    ct$source(system.file("js/colormap.js", package="colormap"))
  }
}

.onLoad <- function(libname, pkgname) {
  initV8()
}
