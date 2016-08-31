
<!-- README.md is generated from README.Rmd. Please edit that file -->
Color Palettes from Node.js Colormap module.
============================================

This is an R package that allows you to generate colors from color palettes defined in Node [colormap](https://github.com/bpostlethwaite/colormap) module. In addition it provides scales functions for use in ggplot2 plots. In total it provides 44 distinct palettes made from sequential and/or diverging colors.

Credits
-------

-   The [colormap](https://github.com/bpostlethwaite/colormap) Node.js module which does all the heavylifting.
-   The [V8](https://github.com/jeroenooms/V8) package which allows R code to call Javascript code.
-   [Bob Rudis](https://twitter.com/hrbrmstr)'s [zoneparser](https://github.com/hrbrmstr/zoneparser) package which I used as a skeleton for this pacakge.
-   [Simon Garnier](https://twitter.com/sjmgarnier)'s [viridis](https://github.com/sjmgarnier/viridis) package for ggplot2 scale functions.

Updates
-------

[![Travis-CI Build Status](https://travis-ci.org/bhaskarvk/colormap.svg?branch=master)](https://travis-ci.org/bhaskarvk/colormap)

-   2016-08-30 Input Validation and ggplot2 scales.
-   2016-08-29 First Release.

Installation
------------

Requires [V8](https://cran.r-project.org/web/packages/V8/index.html)

``` r
if(!require("V8")) install.packages("V8")
if(!require("devtools")) install.packages("devtools")
devtools::install_github("bhaskarvk/colormap")
```

Usage
-----

The main function is `colormap` which takes 5 optional arguments

-   colormap: A string representing one of the 44 built-in colormaps.You can use the `colormaps` list to specify a value. e.g. `colormaps$density`
-   nshades: Number of colors to generate.
-   format: one of 'hex', 'rgb', 'rgbaString'
-   alpha: Between 0 & 1 to specify the transparency.
-   reverse: Boolean. Whether to reverse the order of the colors returned or not.

Example
-------

``` r
library(colormap)

colormap() # Defaults to 72 colors from the 'jet' palette.
#>  [1] "#000083ff" "#000687ff" "#000e8cff" "#001390ff" "#001b95ff"
#>  [6] "#00239aff" "#00299dff" "#0030a2ff" "#0036a6ff" "#003caaff"
#> [11] "#0048afff" "#0152b3ff" "#015eb9ff" "#0167bdff" "#0174c2ff"
#> [16] "#0280c8ff" "#0289ccff" "#0296d1ff" "#039fd5ff" "#03abdbff"
#> [21] "#03b8e0ff" "#03c1e4ff" "#04cde9ff" "#04d7edff" "#04e3f3ff"
#> [26] "#05f0f8ff" "#05f9fcff" "#09fffbff" "#15ffefff" "#25ffdfff"
#> [31] "#35ffceff" "#41ffc2ff" "#50ffb2ff" "#5cffa6ff" "#6cff96ff"
#> [36] "#7cff86ff" "#88ff79ff" "#98ff69ff" "#a8ff59ff" "#b4ff4dff"
#> [41] "#c3ff3dff" "#cfff31ff" "#dfff20ff" "#efff10ff" "#fbff04ff"
#> [46] "#fff700ff" "#ffeb00ff" "#fedb00ff" "#feca00ff" "#febe00ff"
#> [51] "#fdae00ff" "#fda200ff" "#fd9200ff" "#fd8200ff" "#fc7500ff"
#> [56] "#fc6500ff" "#fc5900ff" "#fb4900ff" "#fb3900ff" "#fb2d00ff"
#> [61] "#fb1c00ff" "#fa1000ff" "#fa0000ff" "#ee0000ff" "#e20000ff"
#> [66] "#d30000ff" "#c70000ff" "#b70000ff" "#a70000ff" "#9c0000ff"
#> [71] "#8c0000ff" "#800000ff"

colormap(colormap=colormaps$temperature, nshades=20) # Diff Palette
#>  [1] "#042333ff" "#0c2a50ff" "#13306dff" "#253582ff" "#403891ff"
#>  [6] "#593d9cff" "#6b4596ff" "#7e4e90ff" "#90548bff" "#a65c85ff"
#> [11] "#b8627dff" "#cc6a70ff" "#de7065ff" "#eb8055ff" "#f68f46ff"
#> [16] "#f9a242ff" "#f9b641ff" "#f7cb44ff" "#efe350ff" "#e8fa5bff"

colormap(format='rgb',nshades=10) # As rgb
#>       [,1] [,2] [,3] [,4]
#>  [1,]    0    0  131    1
#>  [2,]    0   54  166    1
#>  [3,]    2  134  202    1
#>  [4,]    4  224  242    1
#>  [5,]   72  255  186    1
#>  [6,]  188  255   69    1
#>  [7,]  254  215    0    1
#>  [8,]  252   97    0    1
#>  [9,]  238    0    0    1
#> [10,]  128    0    0    1

colormap(format='rgb',nshades=10,alpha=0.5) # Constant alpha
#>       [,1] [,2] [,3] [,4]
#>  [1,]    0    0  131  0.5
#>  [2,]    0   54  166  0.5
#>  [3,]    2  134  202  0.5
#>  [4,]    4  224  242  0.5
#>  [5,]   72  255  186  0.5
#>  [6,]  188  255   69  0.5
#>  [7,]  254  215    0  0.5
#>  [8,]  252   97    0  0.5
#>  [9,]  238    0    0  0.5
#> [10,]  128    0    0  0.5

colormap(format='rgbaString',nshades=10) # As rgba string
#>  [1] "rgba(0,0,131,1)"    "rgba(0,54,166,1)"   "rgba(2,134,202,1)" 
#>  [4] "rgba(4,224,242,1)"  "rgba(72,255,186,1)" "rgba(188,255,69,1)"
#>  [7] "rgba(254,215,0,1)"  "rgba(252,97,0,1)"   "rgba(238,0,0,1)"   
#> [10] "rgba(128,0,0,1)"
```

You also get `scale_fill_colormap` and `scale_color_colormap` functions for using these palettes in ggplot2 plots. Check `?colormap::scale_fill_colormap` for details.

``` r
library(ggplot2)

# Continuous color scale
ggplot(mtcars,aes(x=wt,y=mpg)) + geom_point(aes(color=hp)) +
  theme_minimal() +
  scale_color_colormap('Horse Power',
                       discrete = F,colormap = colormaps$viridis, reverse = T)
```

![](README-ggplot2-1.png)

``` r

ggplot(mtcars,aes(x=wt,y=mpg)) + geom_point(aes(color=as.factor(cyl))) +
  theme_minimal() +
  scale_color_colormap('Cylinder',
                       discrete = T,colormap = colormaps$warm, reverse = T)
```

![](README-ggplot2-2.png)

Here are two choroplethes using `scale_fill_colormap`.

``` r
library(maptools)
#> Loading required package: sp
#> Checking rgeos availability: TRUE
library(scales)
library(ggplot2)
library(ggalt)
library(albersusa)
library(ggthemes)
library(colormap)

us <- usa_composite()
us_map <- fortify(us, region="name")

gg_usa <- ggplot()
gg_usa <- gg_usa + geom_map(data=us_map, map=us_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0.1, fill=NA)
gg_usa <- gg_usa + theme_map()
gg_usa <- gg_usa + 
  geom_map(data=us@data, map=us_map,
           aes(fill=pop_2014, map_id=name),
           color="white", size=0.1) +
  coord_proj(us_laea_proj) +
  theme(legend.position="right")

gg_usa +
  scale_fill_colormap("State Population\n(2014 Estimates)", labels=comma,
                      colormap = colormaps$copper, reverse = T, discrete = F)
```

![](README-maps-1.png)

``` r


counties <- counties_composite()

counties_map <- fortify(counties, region="fips")

gg_counties <- ggplot()
gg_counties <- gg_counties + geom_map(data=counties_map, map=counties_map,
                    aes(x=long, y=lat, map_id=id),
                    color="#2b2b2b", size=0.1, fill=NA)
gg_counties <- gg_counties + theme_map() +
  coord_proj(us_laea_proj) +
  theme(legend.position="right")
gg_counties <- gg_counties + 
  geom_map(data=counties@data, map=counties_map,
           aes(fill=population/census_area, map_id=fips),
           color="white", size=0.1)
gg_counties +
  scale_fill_colormap("County Population Density", labels=comma, trans = 'log10',
                      colormap = colormaps$cubehelix, reverse = T, discrete = F)
```

![](README-maps-2.png)

Here is a plot showing all possible palettes.

``` r
par(mfrow=c(44,1))
par(mar=rep(0.25,4))
purrr::walk(colormaps, function(x) { 
  barplot(rep(1,72), yaxt="n", space=c(0,0),border=NA,
          col=colormap(colormap=x), main = sprintf("\n\n%s",x))
  })
```

![](README-plot-1.png)
