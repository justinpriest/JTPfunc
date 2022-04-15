
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Package JTPfunc

A random collection of miscellaneous functions.

### Installation

You can install the development version of JTPfunc from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("justinpriest/JTPfunc")
```

## Example Functions

There are many unique functions contained here, many with esoteric
applications to ADF&G data.

### Function `statweek()`

To calculate the statistical week (Sunday-Saturday), use function
`statweek()` on a date object to return the stat week:

``` r
statweek(as.Date("2021-07-01"))
#> [1] 27
```

### Function `theme_crisp()`

One applicable extension is a ggplot theme called with `theme_crisp()`:

``` r
library(JTPfunc)
library(ggplot2)
ggplot(mtcars, aes(x = wt, y = mpg, color = wt)) + geom_point() + theme_crisp()
```

<img src="man/figures/README-exampleplot-1.png" width="100%" />

### Function `duplicaterows()`

For certain types of date (e.g., age summaries from the scale database)
the data are exported in an already summarized manner. That is, all fish
of the same date, species, sex, length, etc. are combined into a single
row.  
If we wish to run statistics on these data, it is helpful to have each
row be its own observation.  
Our example data look like:

``` r
coholengthdata 
#> # A tibble: 4 x 4
#>   Species Sex   Length Count
#>   <chr>   <chr>  <int> <int>
#> 1 Coho    M        621     1
#> 2 Coho    F        497     2
#> 3 Coho    M        557     3
#> 4 Coho    F        563     1
```

To add new rows to these data, we use function `duplicaterows()`,
specifying which row is the number of times to repeat. We can see that
the row with the two 497 mm female coho is repeated twice while the row
with three 557 mm male coho is repeated 3 times:

``` r
duplicaterows(dataframename = coholengthdata, 
              duplicatecolname = "Count")
#> # A tibble: 7 x 3
#>   Species Sex   Length
#>   <chr>   <chr>  <int>
#> 1 Coho    M        621
#> 2 Coho    F        497
#> 3 Coho    F        497
#> 4 Coho    M        557
#> 5 Coho    M        557
#> 6 Coho    M        557
#> 7 Coho    F        563
```

### Function `count_pct()`

A common request is to determine the proportion of observations for each
group of data. Assuming that each row is an individual, we can calculate
a quick summary using `count_pct()` like so:

``` r
count_pct(iris %>%
           group_by(Species))
#> # A tibble: 3 x 3
#>   Species        n n_pct
#>   <fct>      <int> <dbl>
#> 1 setosa        50  33.3
#> 2 versicolor    50  33.3
#> 3 virginica     50  33.3
```

### Function `addrowconditional()`

For the following example, we’ll use hypothetical rockfish catch data.  
In some historical datasets, catches were not identified to a specific
species but rather to species aggregates. For example, species code 168
refers to unspecified demersal shelf rockfishes while species code 140
is red rockfishes.

``` r
head(rockfishcatch)
#> # A tibble: 6 x 4
#>    Year Location Species Catch
#>   <int> <fct>      <int> <int>
#> 1  2010 Outer        140    12
#> 2  2010 Inner        140    33
#> 3  2010 Middle       140    19
#> 4  2010 Outer        168    33
#> 5  2010 Inner        168    27
#> 6  2010 Middle       168    24
```

For these data, the total catch of the species aggregates (species 140
and 168) was composed of several species. For this reason, these species
may require adding additional rows so that the total catch may be
apportioned. In our example, we repeat all rows of species 168 three
times, and repeat rows of species 140 two times, then sort by year and
species:

``` r
addrowconditional(rockfishcatch, criteriacolumn = Species,
                   repeatcount1 = 3, repeatcount2 = 2,
                   criteria1 = 168, criteria2 = 140,
                   sort1 = Year, sort2 = Species)
#> Joining, by = c("Year", "Location", "Species", "Catch")
#> Joining, by = c("Year", "Location", "Species", "Catch")
#> # A tibble: 33 x 4
#>     Year Location Species Catch
#>    <int> <fct>      <int> <int>
#>  1  2010 Outer        110    33
#>  2  2010 Inner        110    27
#>  3  2010 Middle       110    24
#>  4  2010 Outer        140    12
#>  5  2010 Inner        140    33
#>  6  2010 Middle       140    19
#>  7  2010 Outer        140    12
#>  8  2010 Inner        140    33
#>  9  2010 Middle       140    19
#> 10  2010 Outer        168    33
#> # ... with 23 more rows
```
