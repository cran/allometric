setOldClass("units")
setOldClass("BibEntry")
setOldClass("tbl_df")

check_allometric_model_validity <- function(object) {
  errors <- c()
  errors <- c(errors, check_descriptor_validity(object@descriptors))
  if (length(errors) == 0) TRUE else errors
}

model_types_defined <- utils::read.csv(
  system.file(
  "variable_defs", "model_types_defined.csv",
  package="allometric"
))

.AllometricModel <- setClass("AllometricModel",
  slots = c(
    response_unit = "list",
    covariate_units = "list",
    predict_fn = "function",
    descriptors = "tbl_df",
    set_descriptors = "tbl_df",
    pub_descriptors = "tbl_df",
    citation = "BibEntry",
    covariate_definitions = "list",
    model_type = "character"
  ),
  validity = check_allometric_model_validity
)

#' Base class for allometric models
#'
#' This class is primarily used as a parent class for other model
#' implementations.
#'
#' @param response_unit
#'    A named list containing one element, with a name representing the response
#'    variable and a value representing the units of the response variable
#'    using the `units::as_units` function.
#' @param covariate_units
#'    A named list containing the covariate specifications, with names
#'    representing the covariate name and the values representing the units of
#'    the coavariate using the `units::as_units` function
#' @param descriptors
#'    An optional list of descriptors that are specified at the model-level
#' @param covariate_definitions
#'    A named list of covariate definitions that
#'    are used instead of the descriptions given by the variable naming system
#' @param predict_fn
#'    A function that takes the covariate names as arguments and returns a
#'    prediction of the response variable. This function should be vectorized.
#' @param descriptors
#'    An optional named list of descriptors that describe the context of the
#'    allometric model
#' @param covariate_definitions
#'    An optional named list of custom covariate definitions that will supersede
#'    the definitions given by the variable naming system.
#' @return An instance of an AllometricModel
#' @export
#' @keywords internal
AllometricModel <- function(response_unit, covariate_units, predict_fn,
                            descriptors = list(),
                            covariate_definitions = list()) {
  # Coerce to tibble
  descriptors <- tibble::as_tibble(descriptors)

  # Retrieve the model type
  model_type <- get_model_type(names(response_unit)[[1]])

  allometric_model <- .AllometricModel(
    response_unit = response_unit,
    covariate_units = covariate_units,
    predict_fn = predict_fn,
    descriptors = descriptors,
    set_descriptors = tibble::tibble(),
    pub_descriptors = tibble::tibble(),
    citation = RefManageR::BibEntry(
      bibtype = "misc", title = "", author = "", year = 0
    ),
    covariate_definitions = covariate_definitions,
    model_type = model_type
  )

  allometric_model
}

setMethod(
  "get_measure_name",
  signature(x = "AllometricModel"),
  function(x) {
    response_name <- names(x@response_unit)[[1]]
    measure <- substr(response_name, 1, 1)
    measure_defs[measure_defs$measure == measure, "measure_name"]
  }
)

setMethod(
  "get_component_name",
  signature(x = "AllometricModel"),
  function(x) {
    response_name <- names(x@response_unit)[[1]]
    component <- substr(response_name, 2, 2)
    component_defs[component_defs$component == component, "component_name"]
  }
)

setMethod(
  "Cite",
  signature(x = "AllometricModel"),
  function(x) {
    RefManageR::Cite(x@citation)
  }
)