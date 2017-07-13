# `rmonad`

Chain monadic sequences into stateful, branching pipelines.

You may use `rmonad` to

 * build linear pipelines, as with `magrittr`

 * access results at any step within the pipeline

 * access results preceding an error

 * handle errors naturally

 * call effects -- e.g. plotting, caching -- within a pipeline

 * branch or merge pipelines, while preserving their history

 * annotate nodes in the graph

 * benchmark a pipeline to find bottleknecks in time and space 


## Installation

You can install from github with:


```r
# install.packages("devtools")
devtools::install_github("arendsee/rmonad")
```

## Examples

For details, see the vignette. Here are a few excerpts


```r
library(rmonad)
```


### Record history and access inner values


```r
1:5      %>>%
    sqrt %v>% # record an intermediate value
    sqrt %>>%
    sqrt
#> R> "1:5"
#> R> "sqrt"
#> [1] 1.000000 1.414214 1.732051 2.000000 2.236068
#> 
#> R> "sqrt"
#> R> "sqrt"
#> 
#>  ----------------- 
#> 
#> [1] 1.000000 1.090508 1.147203 1.189207 1.222845
```


### Add effects inside a pipeline


```r
# Both plots and summarizes an input table
cars %>_% plot(xlab="index", ylab="value") %>>% summary
```


### Use first successful result


```r
x <- list()

# return first value in a list, otherwise return NULL
if(length(x) > 0) {
    x[[1]]
} else {
    NULL
}
#> NULL

# this does the same
x[[1]] %||% NULL %>% esc
#> NULL
```


### Independent evaluation of multiple expressions


```r
lsmeval(
    runif(5),
    stop("stop, drop and die"),
    runif("df"),
    1:10
)
#> R> "1:10"
#> R> "runif("df")"
#>  * ERROR: invalid arguments
#>  * WARNING: NAs introduced by coercion
#> R> "stop("stop, drop and die")"
#>  * ERROR: stop, drop and die
#> R> "runif(5)"
#> R> "lsmeval(runif(5), stop("stop, drop and die"), runif("df"), 1:10)"
#> 
#>  ----------------- 
#> 
#> [[1]]
#> [1] 0.5120101 0.8351271 0.8930770 0.4460601 0.2983039
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> NULL
#> 
#> [[4]]
#>  [1]  1  2  3  4  5  6  7  8  9 10
#> 
#>  *** FAILURE ***
```


### Build branching pipelines


```r
lsmeval(
    read.csv("a.csv") %>>% do_analysis_a,
    read.csv("b.csv") %>>% do_analysis_b,
    k = 5
) %*>% joint_analysis
```


### Chain independent pipelines, with documentation


```r
runif(5) %>>% abs %>% doc(

    "Alternatively, the documentation could go into a text block below the code
    in a knitr document. The advantage of having documentation here, is that it
    is coupled unambiguously to the generating function. These annotations,
    together with the ability to chain chains of monads, allows whole complex
    workflows to be built, with the results collated into a single object. All
    errors propagate exactly as errors should, only affecting downstream
    computations. The final object can be converted into a markdown document
    and automatically generated function graphs."

                  ) %>^% sum %__%
rnorm(6)   %>>% abs %>^% sum %v__%
rnorm("a") %>>% abs %>^% sum %__%
rexp(6)    %>>% abs %>^% sum %T>%
  { print(mtabulate(.)) } %>% missues
#>          code    OK cached  time space nbranch nnotes nwarnings error doc
#> 2    runif(5)  TRUE  FALSE    NA    NA       0      0         0     0   0
#> 21        sum  TRUE   TRUE 0.001    NA       0      0         0     0   0
#> 3         abs  TRUE  FALSE 0.001    88       1      0         0     0   1
#> 4    rnorm(6)  TRUE  FALSE    NA    NA       0      0         0     0   0
#> 5         sum  TRUE   TRUE 0.001    NA       0      0         0     0   0
#> 6         abs  TRUE   TRUE 0.001    88       1      0         0     0   0
#> 7  rnorm("a") FALSE  FALSE    NA     0       0      0         1     1   0
#> 8     rexp(6)  TRUE  FALSE    NA    NA       0      0         0     0   0
#> 9         sum  TRUE   TRUE 0.001    NA       0      0         0     0   0
#> 10        abs  TRUE   TRUE 0.000    88       1      0         0     0   0
#>   id    type                      issue
#> 1  7   error          invalid arguments
#> 2  7 warning NAs introduced by coercion
```
