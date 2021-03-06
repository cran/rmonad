#' Render an Rmonad graph
#'
#' Convert the Rmonad object to a DiagrammeR graph and then render it
#'
#' The nodes in the graph represent both a function and the function's output.
#' The edges are relationships between nodes. In an unnested pipeline, every
#' edge represents data flow from source to sink (solid black edges). Nested
#' pipelines contain three additional edge types: a transitive edge, where a
#' node is dependent on a value that was passed to its parent (dotted gray
#' line); a nest edge linking a node to the nested node that produced its value
#' (solid red line); a 'prior' edge for pipelines coupled with the \code{\%__\%}
#' operator (thick dotted blue line).
#'
#' @param x An Rmonad object
#' @param y This variable is currently ignored
#' @param label The node labels. If NULL, the node labels will equal node ids.
#' It may be one of the strings ['code', 'time', 'space', 'value', 'depth']. If
#' 'value' is selected, nodes with no value cached are represented with '-'.
#' Alternatively, it may be a function that maps a single Rmonad object to a
#' string.
#' @param color How to color the nodes. Default is 'status', which colors green
#' for passing, orange for warning, and red for error. Alternatively, color can
#' be a function of an Rmonad object, which will be applied to each node.
#' @param ... Additional arguments passed to plot.igraph. These arguments may
#' override rmonad plotting defaults and behavior specified by the 'label' and
#' 'color' parameters.
#' @export
#' @examples
#' data(gff)
#' # default plot
#' plot(gff$good_result)
#' # turn off vertex labels and set vertex size
#' plot(gff$good_result, vertex.size=10, vertex.label=NA)
plot.Rmonad <- function(x, y, label=NULL, color='status', ...){
  y <- NULL

  opts <- list()

  opts$vertex.label <-
  if(is.function(label)) {
    label(x)               
  } else if(is.null(label)){
    get_id(x)
  } else if(label == "code"){
    vapply(FUN.VALUE=character(1), get_code(x), paste0, collapse="\n")
  } else if(label == "time") {
    get_time(x)
  } else if (label == "space") {
    get_mem(x)
  } else if (label == "depth") {
    get_nest_depth(x)
  } else if (label == "value") {
    ifelse(has_value(x), get_value(x, warn=FALSE), "-")
  } else {
    stop("Something is wrong with the 'label' field")
  }

  opts$vertex.color <-
  if(is.function(color)){
    color(x)
  } else if(color == 'status'){
    ifelse(has_error(x), 'red', 'palegreen') %>%
    {ifelse(has_warnings(x) & !has_error(x), 'yellow', .)}
  } else {
    stop("The 'color' field in plot.Rmonad must be either 'status' or a function")
  }

  # get the edge type, this may be
  # * depend     - black solid  thin
  # * nest       - red   solid  thin
  # * transitive - gray  dotted thin
  # * prior      - blue  dotted thick
  etype <- .get_edge_types(x)
  opts$edge.color <- ifelse(etype == 'depend'     , 'black'  , 'red'           )
  opts$edge.color <- ifelse(etype == 'transitive' , 'gray'   , opts$edge.color )
  opts$edge.color <- ifelse(etype == 'prior'      , 'blue'   , opts$edge.color )
  opts$edge.lty   <- ifelse(etype == 'transitive' , "dotted" , "solid"         )
  opts$edge.lty   <- ifelse(etype == 'prior'      , "dotted" , opts$edge.lty   )
  opts$edge.width <- ifelse(etype == 'prior'      , 3        , 1               )

  # merge all passed arguments into the option list
  passed_opts <- list(...)
  for(opt in names(passed_opts)){
    opts[[opt]] <- passed_opts[[opt]]
  }
  opts <- append(list(x@graph), opts)

  do.call(plot, opts)
}

.scat <- function(s, ...) cat(sprintf(s, ...)) 
.print_record <- function(x, i, verbose=FALSE, value=TRUE) {

  if(has_doc(x, index=i)){
    .scat("\n\n    %s\n\n", .single_doc(x, i))
  }
  .scat('N%s> "%s"', i, paste(.single_code(x, i), collapse="\n"))

  if(verbose && (has_time(x, index=i) || has_mem(x, index=i))){
    cat("\n  ")
    if(has_mem(x, index=i))  { .scat(" size: %s", .single_mem(x, index=i))  }
    if(has_time(x, index=i)) { .scat(" time: %s", .single_time(x, index=i)) }
  }
  if(has_error(x, index=i)){
    .scat("\n * ERROR: %s", .single_error(x, index=i))
  }
  if(has_warnings(x, index=i)){
    .scat("\n * WARNING: %s",
      paste(.single_warnings(x, index=i), collapse="\n * WARNING: ")
    )
  }
  if(has_notes(x, index=i)){
    .scat("\n * NOTE: %s",
      paste(.single_notes(x, index=i), collapse="\n * NOTE: ")
    )
  }
  if(verbose || length(get_parents(x, index=i)) > 1){
    .scat("\nParents: [%s]", paste0(.single_parents(x, index=i), collapse=", "))
  }
  if(has_value(x, index=i) && value){
    cat("\n")
    print(.single_value(x, index=i))
  }
  cat("\n")
}

#' Rmonad print generic function
#'
#' @param x An Rmonad object
#' @param verbose logical print verbose output (include benchmarking)
#' @param value logical print the value wrapped in the Rmonad
#' @param ... Additional arguments (unused)
#' @export
#' @examples
#' m1 <- 256 %v>% sqrt %>>% sqrt %>>% sqrt
#' print(m1)
#' print(m1, verbose=TRUE)
print.Rmonad <- function(x, verbose=FALSE, value=TRUE, ...){

  for(i in seq_len(size(x)-1)){
    .print_record(x, i, value=value, verbose=verbose)
  }
  .print_record(x, size(x), value=FALSE, verbose=verbose)

  if(value){
    if(has_value(x, index=size(x))){ 
      if(size(x) > 1){
        cat("\n ----------------- \n\n")
      }
      print(.single_value(x))
    } else {
      cat("  Final result not cached\n") 
    }
  }

  if(!.single_OK(x)){
    cat(" *** FAILURE *** \n")
  }
}
setMethod("show", "Rmonad",
  function(object) print(object)
)
