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
   calls like `stop()` would be reconed as passing.

## Minor

 * Update README

 * Put docstring first in the printed output 

 * New vignettes

## New bugs

 * Nest level is not set at runtime, but rather set upon conversion to
   a DiagrammeR object. In the meantime, nest depth is NA.


# rmonad 0.1.0

 * Initial release
