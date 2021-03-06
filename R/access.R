#' Vectorized getters for public Rmonad fields
#'
#' @param m An Rmonad object
#' @param index Selection of indices to extract (all by default). The indices
#'              may be a vector of integers, node names, or igraph vertices
#'              (\code{igraph.vs}).
#' @param warn logical In get_value, raise a warning on an attempt to access an uncached node
#' @param tag character vector specifying the tags that must be associated with extracted nodes 
#' @name rmonad_getters
#' @examples
#' data(gff)
#' m <- gff$good_result
#'
#' # vectorized accessors for all stored slots
#' get_value(m, warn=FALSE)
#' get_OK(m)
#' get_code(m)
#' get_dependents(m)
#' get_doc(m)
#' get_error(m)
#' get_id(m)
#' get_mem(m)
#' get_meta(m)
#' get_nest(m)
#' get_nest_depth(m)
#' get_notes(m)
#' get_parents(m)
#' get_prior(m)
#' get_summary(m)
#' get_time(m)
#' get_warnings(m)
#'
#' # get the code associated with long running functions
#' get_code(m)[get_time(m) > 0.1]
#'
#' # Calculate the average node degree
#' nparents <- sapply(get_parents(m), length)
#' nchildren <- sapply(get_dependents(m), length)
#' sum(nparents + nchildren) / size(m) 
NULL

#' Vectorized existence checkers for public Rmonad fields
#'
#' @param m An Rmonad object
#' @param ... Additional arguments passed to \code{get_*} functions
#' @name rmonad_checkers
#' @examples
#' data(gff)
#' m <- gff$good_result
#'
#' has_code(m)
#' has_dependents(m)
#' has_doc(m)
#' has_error(m)
#' has_mem(m)
#' has_meta(m)
#' has_nest(m)
#' has_notes(m)
#' has_parents(m)
#' has_prior(m)
#' has_summary(m)
#' has_time(m)
#' has_value(m)
#' has_warnings(m)
#'
#' # find root nodes
#' which(!has_parents(m))
#'
#' # find terminal (output) nodes
#' which(!has_dependents(m))
#'
#' # count number of independent chains
#' sum(has_prior(m)) + 1
NULL


#' Determine whether something is an Rmonad object
#'
#' @param m Rmonad object
#' @return logical TRUE if m is an Rmonad
is_rmonad <- function(m) {
  setequal(class(m), "Rmonad")
}

# Delete a node's value
#
# @param m Rmonad object
.single_delete_value <- function(m) {
  .single_raw_value(m)@del()
  .single_raw_value(m) <- no_cache()
  m
}

# The purpose of the following functions are to make the setting of things to
# blank (i.e. default, empty, or missing). Simply setting a value to NULL does
# not clearly express intent (are we deleting the value ro do we really want a
# NULL value?). Also there are multiple reasonable defaults (NULL, "", NA,
# NA_integer_, logical(0), etc) and use of the wrong one can be a source of
# subtle of reoccuring bugs. So I gather all this into one place.
.default_value      <- function() void_cache()
.default_key        <- function() .digest(NULL)
.default_tag        <- function() list()
.default_head       <- function() 1L
.default_code       <- function() character(0)
.default_error      <- function() character(0)
.default_warnings   <- function() character(0)
.default_notes      <- function() character(0)
.default_OK         <- function() TRUE
.default_doc        <- function() character(0)
.default_mem        <- function() NA_real_
.default_time       <- function() NA_real_
.default_meta       <- function() list()
.default_depth      <- function() 1L
.default_nest_depth <- function() 1L
.default_stored     <- function() FALSE
.default_id         <- function() integer(0)
.default_summary    <- function() list()
.default_options    <- function() list(keep_grey=FALSE)



# ======================== Vectorized existence checkers =======================

#' @rdname rmonad_checkers
#' @export
has_code <- function(m, ...) sapply(get_code(m, ...), .is_not_empty_string) %>% unname

#' @rdname rmonad_checkers
#' @export
has_tag <- function(m, ...) sapply(get_tag(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_error <- function(m, ...) sapply(get_error(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_doc <- function(m, ...) sapply(get_doc(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_warnings <- function(m, ...) sapply(get_warnings(m , ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_notes <- function(m, ...) sapply(get_notes(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_meta <- function(m, ...) sapply(get_meta(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_time <- function(m, ...) sapply(get_time(m, ...), .is_not_empty_real) %>% unname

#' @rdname rmonad_checkers
#' @export
has_mem <- function(m, ...) sapply(get_mem(m, ...), .is_not_empty_real) %>% unname

#' @rdname rmonad_checkers
#' @export
has_value <- function(m, ...) {
  sapply(
    .get_many_attributes(m, attribute='value', ...),
    function(x) {
      (class(x) == "ValueManager") && x@chk()
    }
  ) %>% unname
}

#' @rdname rmonad_checkers
#' @export
has_parents <- function(m, ...) sapply(get_parents(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_dependents <- function(m, ...) sapply(get_dependents(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_prior <- function(m, ...) sapply(get_prior(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_nest <- function(m, ...) sapply(get_nest(m, ...), function(x) length(x) > 0) %>% unname

#' @rdname rmonad_checkers
#' @export
has_summary <- function(m, ...) sapply(get_summary(m, ...), function(x) length(x) > 0) %>% unname


# ================================ Tag handling ================================

#' Move head to this id
#'
#' @param m rmonad object
#' @param id integer index
#' @export
viewID <- function(m, id){
  .m_check(m)
  .check_type(id, type='index', test=function(x) is.numeric(id) && length(id) == 1)
  m@head <- get_key(m, id)[[1]]
  m
}

#' Return a list of Rmonad objects at these positions
#'
#' @param m rmonad object
#' @param ids integer vector index
#' @export
viewIDs <- function(m, ids){
  .m_check(m)
  .check_type(ids, type='index', test=is.numeric)
  lapply(ids, viewID, m=m)
}

#' Set the head of an Rmonad to a particular tag 
#'
#' Will split on '/'
#'
#' @param m Rmonad object
#' @param ... one or more tag strings specifying a unique node in the pipeline 
#' @return Rmonad object with head reset
#' @export
#' @examples
#' library(magrittr)
#' m <- 256 %v>% sqrt %>% tag('a', 'b') %v>% sqrt
#' esc(view(m, 'a/b'))
#' funnel(view(m, 'a'), m) %*>% sum
view <- function(m, ...){
  .m_check(m)
  x <- .parse_tags(...)
  tags <- .match_tag(m, x$tag)
  if(length(tags) > 1){
    msg <- "The given tag, '%s', is ambiguous, maybe use 'views' instead?"
    stop(sprintf(msg, x$str))
  }
  if(length(tags) == 0){
    msg <- "Tag '%s' not found"
    stop(sprintf(msg, x$str))
  }
  m@head <- igraph::vertex_attr(m@graph)$name[tags[1]]
  m
}

#' Get a list of Rmonad objects matching the given tag
#'
#' @param m Rmonad object
#' @param ... one or more tags
#' @return list of Rmonad objects
#' @export
#' @examples
#' library(magrittr)
#' 1 %>>% prod(2) %>% tag('a/b') %>>%
#'        prod(2) %>% tag('a/c') %>>%
#'        prod(2) %>% tag('a/c') %>>%
#'        prod(2) %>% tag('g/a') -> m
#' views(m, 'a')
views <- function(m, ...){
  .m_check(m)
  x <- .parse_tags(...)
  ids <- .match_tag(m, x$tag, by_prefix=TRUE)
  viewIDs(m, ids)
}

#' Set the tag of an Rmonad object 
#'
#' @param m Rmonad object
#' @param ... one or more tags for the given nodes
#' @param index character or integer vector, specifying the nodes which will be
#' assigned the new tag 
#' @return Rmonad object with new tags
#' @export
#' @examples
#' library(magrittr)
#' 1 %>>% prod(2) %>% tag('a/b') %>>% prod(3) %>% get_tag
#'
tag <- function(m, ..., index=m@head){
  x <- .parse_tags(...)
  if(!is.list(index)){
    index = list(index)
  }
  for(i in index){
    m <- .set_single_attribute(m, attribute='tag', index=i,
                               value=append(get_tag(m, i)[[1]], list(x$tag)))
  }
  m
}

# ============================= Vectorized Getters =============================

#' @rdname rmonad_getters
#' @export
get_parents <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_relative_ids(
    m     = m,
    index = index,
    tag   = tag,
    mode  = "in",
    type  = c("depend", "transitive")
  )
}

#' @rdname rmonad_getters
#' @export
get_dependents <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_relative_ids(m, index=index, tag=tag, mode="out", type="depend")
}

#' @rdname rmonad_getters
#' @export
get_nest <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_relative_ids(m, index=index, tag=tag, mode="in", type="nest")
}

#' @rdname rmonad_getters
#' @export
get_prior <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_relative_ids(m, index=index, tag=tag, mode="in", type="prior")
}

#' @rdname rmonad_getters
#' @export
get_depth <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute='depth') %>% as.integer
}

#' @rdname rmonad_getters
#' @export
get_nest_depth <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute='nest_depth') %>% as.integer
}

#' @rdname rmonad_getters
#' @export
get_value <- function(m, index=.get_ids(m), tag=NULL, warn=TRUE){
  values <- .get_many_attributes(m, index=index, tag=tag, attribute='value')
  lapply(values, function(v) v@get(warn))
}

#' @rdname rmonad_getters
#' @export
get_key <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="key")
}

#' @rdname rmonad_getters
#' @export
get_id <- function(m, index=.get_ids(m), tag=NULL) {
  # FIXME: should I use numeric or vertex ids?
  .get_numeric_ids(m, index=index, tag=tag) %>% as.integer
}

#' @rdname rmonad_getters
#' @export
get_OK <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="OK") %>% as.logical
}

#' @rdname rmonad_getters
#' @export
get_code <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute='code')
}

#' @rdname rmonad_getters
#' @export
get_tag <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute='tag')
}

#' @rdname rmonad_getters
#' @export
get_error <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="error")
}

#' @rdname rmonad_getters
#' @export
get_warnings <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="warnings")
}

#' @rdname rmonad_getters
#' @export
get_notes <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="notes")
}

#' @rdname rmonad_getters
#' @export
get_doc <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="doc")
}

#' @rdname rmonad_getters
#' @export
get_meta <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute='meta')
}

#' @rdname rmonad_getters
#' @export
get_time <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="time") %>% as.numeric
}

#' @rdname rmonad_getters
#' @export
get_mem <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="mem") %>% as.numeric
}

#' @rdname rmonad_getters
#' @export
get_summary <- function(m, index=.get_ids(m), tag=NULL) {
  .get_many_attributes(m, index=index, tag=tag, attribute="summary")
}



# ============== Public setters ================================================
# Not all fields SHOULD be settable. For example, I can conceive of no reason
# why `time` should ever be reset. There are cases where the `ValueManager`
# object stored in the `value` slot may be changed (for example, to remove a
# value from cache or change how it is cached), but care must be taken to
# change only the wrapper, not the pure value. It is possible to set fields
# directly, e.g. `m@data[[1]]@doc <- ...`. For now, I will just add commented
# functions for the fields I think ought to be settable:
#
# set_summary  <- function(m){ }
# set_error    <- function(m){ }
# set_warnings <- function(m){ }
# set_notes    <- function(m){ }
# set_meta     <- function(m){ }

# ============== Singular getters and setters (internal use only) ==============

.single_stored <- function(m, ...) {
  stored <- .get_single_attribute(m, attribute="stored", ...)
  if(is.null(stored)){
    FALSE
  } else {
    stored
  }
}
`.single_stored<-` <- function(m, value) {
  .set_single_attribute(m, attribute="stored", value=value)
}

.single_dependents <- function(m, ...) {
  .get_single_relative_ids(m, mode="out", type="depend", ...)
}
# no setter - see inherit

.single_prior <- function(m, ...) {
  .get_single_relative_ids(m, mode="in", type="prior", ...)
}
# no setter - see inherit

.single_id <- function(m, index=m@head) {
  .m_check(m)
  index
}
# no setter - automatically handled

.single_OK <- function(m, ...) {
  .get_single_attribute(m, attribute="OK", ...)
}
`.single_OK<-` <- function(m, value) {
  .check_type(value, 'logical')
  .set_single_attribute(m, attribute="OK", value=value)
}

.single_value <- function(m, warn=TRUE, ...){
  .get_single_attribute(m, attribute = 'value', ...)@get(warn=warn)
}
`.single_value<-` <- function(m, value) {
  .set_single_attribute(m, attribute="value", value=memory_cache(value))
}

.single_key <- function(m, ...) {
  .get_single_attribute(m, attribute="key", ...)
}
`.single_key<-` <- function(m, value) {
  .check_type(value, type="md5sum", test=is.character)
  .set_single_attribute(m, attribute="key", value=value)
}

.single_raw_value <- function(m, ...){
  .get_single_attribute(m, attribute = 'value', ...)
}
`.single_raw_value<-` <- function(m, value) {
  .set_single_attribute(m, attribute="value", value=value)
}

.single_code <- function(m, ...) {
  .get_single_attribute(m, attribute="code", ...)
}
`.single_code<-` <- function(m, value) {
  .set_single_attribute(m, attribute="code", value=value)
}

.single_tag <- function(m, ...) {
  .get_single_attribute(m, attribute="tag", ...)
}
`.single_tag<-` <- function(m, value) {
  .check_type(value, 'character')
  .set_single_attribute(m, attribute="tag", value=value)
}

.single_error <- function(m, ...) {
  .get_single_attribute(m, attribute="error", ...)
}
`.single_error<-` <- function(m, value) {
  .set_single_attribute(m, attribute="error", value=value)
}

.single_warnings <- function(m, ...) {
  .get_single_attribute(m, attribute="warnings", ...)
}
`.single_warnings<-` <- function(m, value) {
  .set_single_attribute(m, attribute="warnings", value=value)
}

.single_notes <- function(m, ...) {
  .get_single_attribute(m, attribute="notes", ...)
}
`.single_notes<-` <- function(m, value) {
  .set_single_attribute(m, attribute="notes", value=value)
}

.single_doc <- function(m, ...) {
  .get_single_attribute(m, attribute="doc", ...)
}
`.single_doc<-` <- function(m, value) {
  .set_single_attribute(m, attribute="doc", value=value)
}

.single_meta <- function(m, ...) {
  .get_single_attribute(m, attribute="meta", ...)
}
`.single_meta<-` <- function(m, value) {
  .set_single_attribute(m, attribute="meta", value=value)
}

.single_time <- function(m, ...) {
  .get_single_attribute(m, attribute="time", ...)
}
`.single_time<-` <- function(m, value) {
  .set_single_attribute(m, attribute="time", value=value)
}

.single_mem <- function(m, ...) {
  .get_single_attribute(m, attribute="mem", ...)
}
`.single_mem<-` <- function(m, value) {
  .set_single_attribute(m, attribute="mem", value=value)
}

.single_summary <- function(m, ...) {
  .get_single_attribute(m, attribute="summary", ...)
}
`.single_summary<-` <- function(m, value){
  .set_single_attribute(m, attribute="summary", value=value)
}

.single_parents <- function(m, ...) {
  .get_single_relative_ids(m, mode="in", type=c("depend", "transitive"), ...)
}
`.single_parents<-` <- function(m, value) {
  .add_parents(m, value, check=has_parents, type="depend")
}

.single_nest <- function(m, ...) {
  .get_single_relative_ids(m, mode="in", type="nest", ...)
}
`.single_nest<-` <- function(m, value) {
  # `value` is the Rmonad that will be nested inside `m`
  # `value` is the "parent", since its value will be passed to `m`
  if(.single_OK(value)){
    .inherit(
      child         = m,
      parent        = value,
      inherit_value = TRUE,
      inherit_OK    = TRUE,
      force_keep    = FALSE,
      type          = "nest"
    )
  } else {
    m <- .inherit(
      child         = m,
      parent        = value,
      inherit_value = FALSE,
      inherit_OK    = TRUE,
      force_keep    = TRUE,
      type          = "nest"
    )
    .single_raw_value(m) <- void_cache()
    m
  }
}

.single_depth <- function(m, ...) {
  .get_single_attribute(m, attribute="depth", ...)
}
`.single_depth<-` <- function(m, value) {
  .set_single_attribute(m, attribute="depth", value=value)
}

.single_nest_depth <- function(m, ...) {
  .get_single_attribute(m, attribute="nest_depth", ...)
}
`.single_nest_depth<-` <- function(m, value) {
  .set_single_attribute(m, attribute="nest_depth", value=value)
}
