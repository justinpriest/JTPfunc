
<!-- README.md is generated from README.Rmd. Please edit that file -->

# JTPfunc

<!-- badges: start -->
<!-- badges: end -->

A random collection of miscellaneous functions.

## Installation

You can install the development version of JTPfunc from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("justinpriest/JTPfunc")
```

## Example Functions

There are many unique functions contained here, many with esoteric
applications to ADF&G data.

One applicable extension is a ggplot theme called with `theme_crisp()`:

``` r
library(JTPfunc)
library(ggplot2)
ggplot(mtcars, aes(x = wt, y = mpg, color = wt)) + geom_point() + theme_crisp()
```

<img src="man/figures/README-exampleplot-1.png" width="100%" />
