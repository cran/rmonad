## ---- echo=FALSE, message=FALSE------------------------------------------
library(rmonad)
library(magrittr)
set.seed(210)

## ------------------------------------------------------------------------
# %>>% corresponds to Haskell's >>=
1:5      %>>%
    sqrt %>>%
    sqrt %>>%
    sqrt

## ------------------------------------------------------------------------
1:5      %>%
    sqrt %>%
    sqrt %>%
    sqrt

## ------------------------------------------------------------------------
1:5      %>>%
    sqrt %v>% # store this result
    sqrt %>>%
    sqrt

## ------------------------------------------------------------------------
1:5 %>>% { o <- . * 2 ; { o + . } %>% { . + o } }

## ------------------------------------------------------------------------
-1:3     %>>%
    sqrt %v>%
    sqrt %>>%
    sqrt

## ------------------------------------------------------------------------
"wrench" %>>%
    sqrt %v>%
    sqrt %>>%
    sqrt

## ---- error=TRUE---------------------------------------------------------
"wrench" %>%
    sqrt %>%
    sqrt %>%
    sqrt

## ------------------------------------------------------------------------
1:5 %>>% sqrt %>% esc

## ---- error=TRUE---------------------------------------------------------
"wrench" %>>% sqrt %>>% sqrt %>% esc

## ------------------------------------------------------------------------
1:5      %>>%
    sqrt %v>%
    sqrt %>>%
    sqrt %>% mtabulate

## ------------------------------------------------------------------------
-2:2 %>>% sqrt %>>% colSums %>% missues

## ------------------------------------------------------------------------
result <- 1:5 %v>% sqrt %v>% sqrt %v>% sqrt
as.list(result)[[2]] %>% esc

## ---- eval=FALSE---------------------------------------------------------
#  cars %>_% write.csv(file="cars.tab") %>>% summary

## ------------------------------------------------------------------------
cars %>_% plot(xlab="index", ylab="value") %>>% summary %>% forget

## ---- eval=FALSE---------------------------------------------------------
#  cars                                 %>_%
#      plot(xlab="index", ylab="value") %>_%
#      write.csv(file="cars.tab")       %>>%
#      summary %>% forget

## ------------------------------------------------------------------------
iris                                    %>_%
    { stopifnot(is.data.frame(.))     } %>_%
    { stopifnot(sapply(.,is.numeric)) } %>>%
    colSums %|>% head

## ------------------------------------------------------------------------
1:10 %>>% colSums %|>% sum

## ---- eval=FALSE---------------------------------------------------------
#  # try to load a cached file, on failure rerun the analysis
#  read.table("analyasis_cache.tab") %||% run_analysis(x)

## ------------------------------------------------------------------------
x <- list()
# compare
if(length(x) > 0) { x[[1]] } else { NULL }
# to 
x[[1]] %||% NULL %>% esc

## ---- eval=FALSE---------------------------------------------------------
#  read.table("a.tab") %||% read.table("a.tsv") %>>% dostuff

## ------------------------------------------------------------------------
letters[1:10] %v>% colSums %|>% sum %||% message("Can't process this")

## ---- eval=FALSE---------------------------------------------------------
#  rnorm(30) %>^% qplot(xlab="index", ylab="value") %>>% mean

## ---- eval=FALSE---------------------------------------------------------
#  rnorm(30) %>^% qplot(xlab="index", ylab="value") %>^% summary %>>% mean

## ------------------------------------------------------------------------
x <- 1:10 %>^% dgamma(10, 1) %>^% dgamma(10, 5) %^>% cor
x
unbranch(x)

## ------------------------------------------------------------------------
runif(10) %>>% sum %v__%
rnorm(10) %>>% sum %v__%
rexp(10)  %>>% sum

## ---- eval=FALSE---------------------------------------------------------
#  program <-
#  {
#      x = 2
#      y = 5
#      x * y
#  } %v__% {
#      letters %>% sqrt
#  } %v__% {
#      10 * x
#  }

## ------------------------------------------------------------------------
lsmeval(
    "yolo",
    stop("stop, drop, and die"),
    runif("simon"),
    k = 2
)

## ---- error=TRUE---------------------------------------------------------
list( "yolo", stop("stop, drop, and die"), runif("simon"), 2)

## ---- eval=FALSE---------------------------------------------------------
#  lsmeval(read.csv("a.csv"), read.csv("b.csv")) %*>% merge

## ---- eval=FALSE---------------------------------------------------------
#  lsmeval(
#      a = read.csv("a.csv") %>>% do_analysis_a,
#      b = read.csv("b.csv") %>>% do_analysis_b,
#      k = 5
#  ) %*>% joint_analysis

## ------------------------------------------------------------------------
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
  {print(mtabulate(.)) } %>% missues

