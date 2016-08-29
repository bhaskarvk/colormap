
<!-- README.md is generated from README.Rmd. Please edit that file -->
Color Palettes from Node's Colormap module.
===========================================

This is an R package that allows you to generate colors from color palettes defined in Node [colormap](https://github.com/bpostlethwaite/colormap) module.

Installation
------------

``` r
if(!require("devtools")) install.packages("devtools")
devtools::install_github("bhaskarvk/colormap")
```

Usage
-----

There is only one function `colormap` which takes 4 optional arguments

-   colormap: A string representing one of the 44 built-in colormaps.You can use the `colormaps` list to specify a value. e.g. `colormaps$density`
-   nshades: Number of colors to generate. NOTE each palette has a certain mininum required number and if you specify a value below it, the function will throw an error.
-   format: one of 'hex', 'rgb', 'rgbaString'
-   alpha: Either a single value between 0 and 1 or a vector of 2 elements specifying a range.

Example
-------

``` r
library(colormap)

colormap() # Defaults to 72 colors from the 'jet' palette.
#>  [1] "#000083" "#000888" "#000f8d" "#001792" "#001e97" "#00269b" "#002da0"
#>  [8] "#0035a5" "#003caa" "#003caa" "#0047af" "#0153b4" "#015eb9" "#016abe"
#> [15] "#0175c3" "#0281c8" "#028ccd" "#0298d2" "#03a3d7" "#03afdc" "#03bae1"
#> [22] "#04c6e6" "#04d1eb" "#04ddf0" "#04e8f5" "#05f4fa" "#05ffff" "#05ffff"
#> [29] "#14fff0" "#22ffe1" "#31ffd2" "#40ffc3" "#4fffb4" "#5dffa5" "#6cff96"
#> [36] "#7bff87" "#89ff78" "#98ff69" "#a7ff5a" "#b5ff4b" "#c4ff3c" "#d3ff2d"
#> [43] "#e2ff1e" "#f0ff0f" "#ffff00" "#ffff00" "#fff000" "#fee100" "#fed200"
#> [50] "#fec300" "#feb400" "#fda500" "#fd9600" "#fd8700" "#fc7800" "#fc6900"
#> [57] "#fc5a00" "#fb4b00" "#fb3c00" "#fb2d00" "#fb1e00" "#fa0f00" "#fa0000"
#> [64] "#fa0000" "#eb0000" "#dc0000" "#cc0000" "#bd0000" "#ae0000" "#9f0000"
#> [71] "#8f0000" "#800000"

colormap(colormap=colormaps$temperature, nshades=20) # Diff Palette
#>  [1] "#042333" "#0e2b57" "#17337a" "#17337a" "#553b9d" "#553b9d" "#6b4596"
#>  [8] "#814f8f" "#814f8f" "#af5f82" "#af5f82" "#c76874" "#de7065" "#de7065"
#> [15] "#f99242" "#f99242" "#f9ab42" "#f9c441" "#f9c441" "#e8fa5b"

colormap(format='rgb',nshades=10) # As rgb
#>       [,1] [,2] [,3] [,4]
#>  [1,]    0    0  131    1
#>  [2,]    0   60  170    1
#>  [3,]    3  158  213    1
#>  [4,]    5  255  255    1
#>  [5,]    5  255  255    1
#>  [6,]  255  255    0    1
#>  [7,]  255  255    0    1
#>  [8,]  253  128    0    1
#>  [9,]  250    0    0    1
#> [10,]  250    0    0    1

colormap(format='rgb',nshades=10,alpha=0.5) # Constant alpha
#>       [,1] [,2] [,3] [,4]
#>  [1,]    0    0  131  0.5
#>  [2,]    0   60  170  0.5
#>  [3,]    3  158  213  0.5
#>  [4,]    5  255  255  0.5
#>  [5,]    5  255  255  0.5
#>  [6,]  255  255    0  0.5
#>  [7,]  255  255    0  0.5
#>  [8,]  253  128    0  0.5
#>  [9,]  250    0    0  0.5
#> [10,]  250    0    0  0.5

colormap(format='rgb',nshades=10,alpha=c(0.2,08)) # Alpha Range
#>       [,1] [,2] [,3]  [,4]
#>  [1,]    0    0  131 1.000
#>  [2,]    0   60  170 1.875
#>  [3,]    3  158  213 2.750
#>  [4,]    5  255  255 3.625
#>  [5,]    5  255  255 3.625
#>  [6,]  255  255    0 5.375
#>  [7,]  255  255    0 5.375
#>  [8,]  253  128    0 6.250
#>  [9,]  250    0    0 7.125
#> [10,]  250    0    0 7.125

colormap(format='rgbaString',nshades=10) # As rgba string
#>  [1] "rgba(0,0,131,1)"   "rgba(0,60,170,1)"  "rgba(3,158,213,1)"
#>  [4] "rgba(5,255,255,1)" "rgba(5,255,255,1)" "rgba(255,255,0,1)"
#>  [7] "rgba(255,255,0,1)" "rgba(253,128,0,1)" "rgba(250,0,0,1)"  
#> [10] "rgba(250,0,0,1)"
```

Finally all palettes

``` r
par(mfrow=c(44,1))
par(mar=rep(0.25,4))
purrr::walk(colormaps, function(x) { 
  barplot(rep(1,72), yaxt="n", space=c(0,0),border=NA,
          col=colormap(colormap=x), main = sprintf("\n\n%s",x))
  })
```

![](README-plot-1.png)

WARNING
-------

I have noticed that certain palettes don't generate unique colors. From my observation certain palettes can have up to one or two dupes. I have raised a [BUG](https://github.com/bpostlethwaite/colormap/issues/9) upstream, and will fix this package when that gets fixed. In the mean time you can use `unique`.

``` r
# This has no dupes
greys <- colormap(colormap = colormaps$greys)
length(greys)
#> [1] 72
length(unique(greys))
#> [1] 72

# This has dupes
thermal <- colormap(colormap = colormaps$temperature)
length(thermal)
#> [1] 72
length(unique(thermal))
#> [1] 65
```
