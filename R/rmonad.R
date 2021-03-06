#' @importFrom utils capture.output object.size head
#' @importFrom methods new slot 'slot<-'
#' @importFrom graphics plot
utils::globalVariables(c("%>%", "."))
NULL

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`
NULL

#' rmonad: handling pipes, errors, and everything with monads
#'
#' Rmonad merges blocks of code into a graph containing the history of all past
#' operations, and optionally their values. It consists mainly of a set of
#' monadic bind operators for controlling a pipeline and handling error. It
#' also contains functions for operating on monads, evaluating expressions into
#' monads, and extracting values from them. I will briefly introduce the most
#' useful of these here. For more information see the \code{introduction}
#' vignette.
#'
#' @section Basic Operators:
#'
#' \describe{
#'    \item{\code{\%>>\%}}{monadic bind: applies rhs function to the lhs value}
#'    \item{\code{\%v>\%}}{monadic bind: store intermediate result}
#'    \item{\code{\%*>\%}}{bind lhs list as arguments to right. The lhs may be
#'    a literal list or a monad bound list.}
#'    \item{\code{\%>_\%}}{perform rhs action, discard result, pass the lhs}
#'    \item{\code{\%>^\%}}{Bind as a new branch, pass input on main. This
#'    differs from \code{\%>_\%} in that future operations do not depend on its
#'    pass/fail status. Use \code{unbranch} to extract all branches from an
#'    Rmonad object.} 
#'    \item{\code{\%||\%}}{if input is error, use rhs value instead}
#'    \item{\code{\%|>\%}}{if input is error, run rhs on last passing result}
#'    \item{\code{\%__\%}}{keep parents from the lhs (errors ignored). This allows chaining of independent operations.}
#' }
#'
#' @section Operators targeted for deprecation:
#'
#'  \code{\%^>\%} Monadic bind and record input in monad. Perform rhs operation
#'                on lhs branches. I may deprecate this operator.
#'
#' @section x to monad functions:
#'
#' \code{as_monad} - evaluate an expression into a monad (capturing error)
#'
#' \code{funnel} - evaluate expressions into a list inside a monad
#'
#' @section monad to monad functions:
#'
#' \code{forget} - erase parents from a monad
#'
#' \code{combine} - combine a list of monads into a list in a monad
#'
#' @section monad to x functions:
#'
#' \code{esc} - extract the result from a computation
#'
#' \code{mtabulate} - summarize all steps in a pipeline into a table
#'
#' \code{missues} - tabulate all warnings and errors from a pipeline 
#'
#' \code{unbranch} - extract all branches from the pipeline
#'
#' @docType package
#' @name rmonad
#' @examples
#'
#' # chain operations
#' cars %>>% colSums
#'
#' # chain operations with intermediate storing
#' cars %v>% colSums
#'
#' # handle failing monad
#' iris %>>% colSums %|>% head
#' cars %>>% colSums %|>% head
#'
#' # run an effect
#' cars %>_% plot %>>% colSums
#'
#' # return first successful operation
#' read.csv("a.csv") %||% iris %>>% head
#'
#' # join two independent pipelines, preserving history
#' cars %>>% colSums %__% cars %>>% lapply(sd) %>>% unlist
#'
#' # load an expression into a monad, catching errors
#' as_monad(stop("instant death"))
#'
#' # convert multiple expressions into a list inside a monad
#' funnel(stop("oh no"), runif(5), sqrt(-1))

NULL
