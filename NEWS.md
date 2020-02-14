# rmonad 0.7.0

 * Rename `log` rewriter as `format_log`

 * Minor internal bug fixes

# rmonad 0.6.2

 * Fix argument passing to the functions in `loop`
 * Allow multiple tags

 * Add Zenodo UID

# rmonad 0.5.0

## New Features

 * Generalize `make_local_cacher` to take custom functions for saving, getting,
   checking and deleting data.

 * Add `crunch` function to cache all values over a given size that are stored
   in memory.

 * Add `loop` function

 * Add `tag` field to `Rmonad` objects and access functions:

   - `tag` - set the tags of the current head node (or nodes at given indices)

   - `view` - set the head of the graph to the given tagged node

   - `views` - get list of Rmonad objects matching a given tag

   - `viewID` - like view but with ID

   - `viewIDs` - like views but with ID

   - `get_tag` - get tags for nodes

   - `has_tag` - check whether nodes have tags

   - add `tag` argument to `as_monad` to allow tag setting at creation 

   - add `tag` argument to `get_*` to allow access by tag

   - add `tag` to caching functions, to allow tag and cache to be set together

   - give names to elements of lists returned by tag from `get_*` functions


## Changes

 * Node names are now reproducible. If you notice any internal nodes
   disappearing, please file a bug report, since this means we missed some case
   in our hashing system.

 * Use `saveRDS`, rather than `save`, for local caching

 * Change `print.Rmonad` parameter `print_value` to `value`

 * Combine (and funnel) now stores failing inputs as NULL and does not delete
   the failing parent's cache

 * In `combine`/`funnel`, tagged parents are not deleted


## Experimental

 * Add automatic caching, if a function takes a long time to run, it is cached

 * Add option to turn toggle auto caching: `rmonad.auto_cache` (default = FALSE)

 * Add option to set how long an expression can take before its result will be
   cached: `rmonad.cache_maxtime` (default = 3 seconds)

 * Add option to set cache directory: `rmonad.cache_dir` (default = "cache")

 * Add option to set cache function: `rmonad.cacher` (default = `make_cacher()`)


## Bug fixes

 * Fix expression capture in `as_monad`

 * Make `index` the second positional argument of `has_value`, as with other
   accessors

 * Metadata lists are now evaluated in the natural lexical scope, with access
   to the function arguments and variables in the scope where the function was
   defined.


## Other

 * Add vignette showing integration with `Nozzle.R1`

 * Reexport `magrittr` pipe operator


# rmonad 0.4.0

## Conceptual changes

 * Replace the internal ad hoc graph system with 'igraph'

   - `Rmonad` is now an S4 class
 
   - The raw igraph object is stored in the `graph` slot.

   - The vertex attributes are stored in a list in the `data` slot.

 * Replace the concept of "branches" (e.g. the `%>^%` operator) with
   "children". These are just multiple children of a node in a directed graph.

 * Add a flexible cache system

## New functions and arguments

 * Export `size` function that returns the number of nodes in a workflow.

 * The vectorized `ms_*` accessors are renamed as `get_*`.

 * Add `has_*` vectorized accessors for the existence of fields (e.g.
   `has_value`, `has_error`).

 * `plot.Rmonad` is now a wrapper for `plot.igraph`

## Deprecated/internalized functions

 * Remove `as.list`

 * Remove `unbranch`

 * Remove `as_dgr_graph`, now the underlying graph is already an igraph object,
   which can be converted easily to a DiagrammeR graph, if desired

 * Remove all the `ms_*` functions (replaced with `get_*`)

 * Remove all `m_*` functions. They provided access to the "head" of the
   workflow, but this isn't really all that well defined, since `rmonad`
   supports branching.

 * Completely remove deprecated `%v__%` operator and the `doc` and `lsmeval`
   functions.

 * Do not export `unnest` (you don't need it)

 * Rename `mreport` as `report`. The content of the report is updated somewhat,
   but still should be considered as a template.

## Changed parameters

 * in `mtabulate` and `missues`: Deprecate the `recurse_nests` option 

 * in `plot.Rmonad`: pass '...' to `igraph.plot`

## Bug fixes

 * Evaluate metadata in the correct environment

 * Now `nest_depth` is set as the graph grows (in the past it wasn't added
   until `mtabulate` was run).

 * Free memory for values stored in the Rmonad objects when they are combined
   with `funnel`, previously these values were stored even when they should
   have been removed.

 * Fixed lots of bugs and inconsistencies in the vectorized getters.

## Experimental

 The following new features are experimental. I intend to keep them around in
 some form in the future, but the API will likely change.

 * Add rewriter functions that can reformat warning, error, and note message,
   or summarize the result, after an Rmonad is built. These rewriters are set
   in a node's metadata list. The following rewritters are currently supported:  
 
   - `format_warnings` - format warning strings
   - `format_error` - format error strings
   - `format_notes` - format note (message) strings
   - `summarize` - store summaries of the data
   - `cache` - set the caching function
   - `log` - write log

 * Add a cache system, where values are stored as CacheManager objects which
   have three slots: `get`, `del`, and `chk`. These are functions for getting,
   deleting, and checking values in a cache, respectively. Internally, the
   `get` functions may store values in memory (in a closure), locally as
   a Rdata object, or not at all. The following new functions are exported:

   - `make_local_cacher` - build a cache function that stores data as Rdata
     objects in a specified folder.

   - `memory_cache` - cache a value in memory

   - `make_recacher` - build a function to reset an `Rmonad` object's cacher

   - `no_cache` - do not cache the value

   - `clear_cache` - removes all cached values (in memory or storage)


# rmonad 0.3.0

 * Deprecate the `%v__%` operator. Now the `%__%` operator always stores the
   final left-side result.

 * Fix linking to nested history.

 * Fix incorrect history linking bugs caused by the `%__%` operator
 
 * Preserve the inputs to failing nested nodes. Now if a nested node fails, the
   input to that node, and the input to every ascending node, is preserved.
   (like a traceback where the function arguments are saved).

 * Add a new kind of edge. The `%__%` associates two pipelines but does not
   pass data or propagate errors. This was previously treated as one kind of
   'parent' edge; now it is a 'prior' edge.

 * Add special plot handling for 'prior' edges.

# rmonad 0.2.0

## Backwards incompatible changes

 * Rename `lsmeval` as `funnel`

 * `combine` now works exclusively on lists of Rmonad objects

 * Allow nesting of Rmonads, `as_monad` no longer automatically unnests them

 * Deprecate the `doc` function. Instead use doc strings.

## New features

 * Docstrings and metadata in anonymous functions

 * Support for multivariate anonymous functions

 * `as_monad` now records time and space (previously were left as NA)

 * Rmonad class refactored as an R6 class

 * Allow `%*>%` to take monad bound lists

 * `m_value` raises a warning (by default) when accessing an uncached value.

## New functions

 * `mreport` - Generate of rudimentary Markdown reports

 * `as_dgr_graph` - Convert pipeline to DiagrammeR graph 

 * `is_rmonad` - Tests if something is an `Rmonad` object

 * `unnest` - remove a level of nesting from a node

 * `extract_metadata` - get docstring and metadata from a function or block

 * `m_nest` - get or set a node's nested pipeline

 * `m_nest_depth` - get or set a node's nest depth

 * `m_meta` - get or set a node's metadata

 * `m_id` - get or set a node's id (changing an existing id raises a warning)

 * `app_parents` - add a list of parents to a node

 * `m_delete_value` - delete the value stored by a node 

## Fixes

 * `NULL` can now be stored as a value and is distinguishable from Nothing
   (i.e. an uncached value).

 * as.list now lists elements in the expected order

 * Errors raised are stored even if they are not non-empty strings. Previously
   calls like `stop()` would be reckoned as passing.

## Minor

 * Update README

 * Put docstring first in the printed output 

 * New vignettes

## New bugs

 * Nest level is not set at runtime, but rather set upon conversion to
   a DiagrammeR object. In the meantime, nest depth is NA.


# rmonad 0.1.0

 * Initial release
