% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/load.R
\name{load_models}
\alias{load_models}
\title{Load a locally installed table of allometric models}
\usage{
load_models()
}
\value{
A model_tbl containing the locally installed models.
}
\description{
This function loads all locally installed allometric models if they are
downloaded and installed, if not run the \code{install_models} function. The
result is of class \code{model_tbl}, which behaves very much like a
\code{tibble::tbl_df} or a \code{data.frame}.
}
\details{
Printing the \code{head} of \code{allometric_models}, we can see the structure of the
data

\if{html}{\out{<div class="sourceCode r">}}\preformatted{allometric_models <- load_models()
head(allometric_models)
#> # A tibble: 6 x 10
#>   id       model_type  country   region    taxa   pub_id        model      family_name covt_name pub_year
#>   <chr>    <chr>       <list>    <list>    <list> <chr>         <list>     <list>      <list>       <dbl>
#> 1 cc2078aa site index  <chr [1]> <chr [2]> <Taxa> barrett_1978  <FxdEffcM> <chr [1]>   <chr [2]>     1978
#> 2 f50865ee stem volume <chr [1]> <chr [1]> <Taxa> bell_1981     <FxdEffcM> <chr [3]>   <chr [2]>     1981
#> 3 4d35d681 taper       <chr [2]> <chr [3]> <Taxa> bluhm_2007    <FxdEffcM> <chr [3]>   <chr [4]>     2007
#> 4 8d35a7b6 stem volume <chr [1]> <chr [1]> <Taxa> brackett_1977 <FxdEffcM> <chr [1]>   <chr [2]>     1977
#> 5 8682a321 stem volume <chr [1]> <chr [1]> <Taxa> brackett_1977 <FxdEffcM> <chr [1]>   <chr [2]>     1977
#> 6 7cfc15b2 stem volume <chr [1]> <chr [1]> <Taxa> brackett_1977 <FxdEffcM> <chr [1]>   <chr [2]>     1977
}\if{html}{\out{</div>}}

The columns are:
\itemize{
\item \code{id} - A unique ID for the model.
\item \code{model_type} - The type of model (e.g., stem volume, site index, etc.)
\item \code{country} - The country or countries from which the model data is from.
\item \code{region} - The region or regions (e.g., state, province, etc.) from which
the model data is from.
\item \code{taxa} - The taxonomic specification of the trees that are modeled.
\item \code{model} - The model object itself.
\item \code{pub_id} - A unique ID representing the publication.
\item \code{family_name} - The names of the contributing authors.
\item \code{covt_name} - The names of the covariates used in the model.
\item \code{pub_year} - The publication year.
}

Models can be searched by their attributes. Note that some of the columns
are \code{list} columns, which contain lists as their elements. Filtering on
data in these columns requires the use of \code{purrr::map_lgl} which is used to
determine truthiness of expressions for each element in a \code{list} column.
While this may seem complicated, we believe the nested data structures are
more descriptive and concise for storing the models, and users will quickly
find that searching models in this way can be very powerful.
}
\section{Finding Contributing Authors}{
Using \code{purr::map_lgl} to filter the \code{family_name} column, we are able to
find publications that contain specific authors of interst. For example, we
may want models only authored by \code{"Hann"}. This is elementary to do in
\code{allometric}:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{hann_models <- dplyr::filter(
 allometric_models,
 purrr::map_lgl(family_name, ~ 'Hann' \%in\% .)
)

head(hann_models)
#> # A tibble: 6 x 10
#>   id       model_type  country   region    taxa   pub_id    model      family_name covt_name pub_year
#>   <chr>    <chr>       <list>    <list>    <list> <chr>     <list>     <list>      <list>       <dbl>
#> 1 8970949f stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 2 0d53539a stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 3 0d109f2c stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 4 86dcc7ff stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 5 037a7989 stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 6 02614f74 stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
nrow(hann_models)
#> [1] 87
}\if{html}{\out{</div>}}

Picking apart the above code block, we see that we are using the standard
\code{dplyr::filter} function on the \code{allometric_models} dataframe. The second
argument is a call using \code{purrr:map_lgl}, which will map over each list
(contained as elements in the \code{family_names} column). The second argument to
this function, \code{~ 'Hann' \%in\% .} is itself a function that checks if \code{'Hann'}
is in the current list. Imagine we are marching down each row of
\code{allometric_models}, \code{.} represents the element of \code{family_names} we are
considering, which is itself a list of author names.
}

\section{Finding First Authors}{
Maybe we are only interested in models where \code{'Hann'} is the first author.
Using a simple modification we can easily do this.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{hann_first_author_models <- dplyr::filter(
  allometric_models,
  purrr::map_lgl(family_name, ~ 'Hann' == .[[1]])
)

head(hann_first_author_models)
#> # A tibble: 6 x 10
#>   id       model_type  country   region    taxa   pub_id    model      family_name covt_name pub_year
#>   <chr>    <chr>       <list>    <list>    <list> <chr>     <list>     <list>      <list>       <dbl>
#> 1 8970949f stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 2 0d53539a stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 3 0d109f2c stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 4 86dcc7ff stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 5 037a7989 stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
#> 6 02614f74 stem volume <chr [1]> <chr [2]> <Taxa> hann_1978 <FxdEffcM> <chr [2]>   <chr [2]>     1978
nrow(hann_first_author_models)
#> [1] 50
}\if{html}{\out{</div>}}

We can see that \code{'Hann'} is the first author for
50 models in this package.
}

\section{Finding Models for a Given Species}{
One of the most common things people need is a model for a particular
species. For this, we must interact with the \code{taxa} column. For example,
to find models for the Pinus genus we can use

\if{html}{\out{<div class="sourceCode r">}}\preformatted{pinus_models <- dplyr::filter(
 allometric_models,
 purrr::map_lgl(taxa, ~ "Pinus" \%in\% .)
)

head(pinus_models)
#> # A tibble: 6 x 10
#>   id       model_type  country   region    taxa   pub_id         model      family_name covt_name pub_year
#>   <chr>    <chr>       <list>    <list>    <list> <chr>          <list>     <list>      <list>       <dbl>
#> 1 cc2078aa site index  <chr [1]> <chr [2]> <Taxa> barrett_1978   <FxdEffcM> <chr [1]>   <chr [2]>     1978
#> 2 3ab229f7 stem volume <chr [1]> <chr [1]> <Taxa> brackett_1977  <FxdEffcM> <chr [1]>   <chr [2]>     1977
#> 3 4a13ca7e stem volume <chr [1]> <chr [1]> <Taxa> brackett_1977  <FxdEffcM> <chr [1]>   <chr [2]>     1977
#> 4 21d11091 stem volume <chr [1]> <chr [1]> <Taxa> brackett_1977  <FxdEffcM> <chr [1]>   <chr [2]>     1977
#> 5 b1d070b5 stem volume <chr [1]> <chr [1]> <Taxa> chojnacky_1985 <FxdEffcM> <chr [1]>   <chr [3]>     1985
#> 6 a5611fec stem volume <chr [1]> <chr [1]> <Taxa> chojnacky_1985 <FxdEffcM> <chr [1]>   <chr [3]>     1985
nrow(pinus_models)
#> [1] 285
}\if{html}{\out{</div>}}

Users can also search with a specific taxon, which allows a full
specification from family to species. For example, if we want models that
apply to Ponderosa pine, first declare the necessary taxon, then use it to
filter as before

\if{html}{\out{<div class="sourceCode r">}}\preformatted{ponderosa_taxon <- Taxon(
 family = "Pinaceae", genus = "Pinus", species = "ponderosa"
)

ponderosa_models <- dplyr::filter(
 allometric_models,
 purrr::map_lgl(taxa, ~ ponderosa_taxon \%in\% .)
)

nrow(ponderosa_models)
#> [1] 57
}\if{html}{\out{</div>}}
}

\section{Finding a Model with Specific Data Requirements}{
We can even check for models that contain certain types of data requirements.
For example, the following block finds diameter-height models, specifically
models that use diameter outside bark at breast height as the \emph{only}
covariate. The utility here is obvious, since many inventories are vastly
limited by their available tree measurements.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{dia_ht_models <- dplyr::filter(
    allometric_models,
    model_type == 'stem height',
    purrr::map_lgl(covt_name, ~ length(.)==1 & .[[1]] == 'dsob'),
)

nrow(dia_ht_models)
#> [1] 241
}\if{html}{\out{</div>}}

Breaking this down, we have the first condition \code{model_type=='stem_height'}
selecting only models concerned with stem heights as a response variable. The
second line maps over each element of the \code{covt_name} column, which is a
character vector. The \code{.} represents a given character vector for that row.
First, we ensure that the vector is only one element in size using
\code{length(.)==1}, then we ensure that the first (and only) element of this
vector is equal to \code{'dsob'}, (diameter outside bark at breast height). In
this case, 241 are available in the package.
}

\section{Finding a Model for a Region}{
By now the user should be sensing a pattern. We can apply the exact same
logic as the \emph{Finding Contributing Authors} section to find all models
developed using data from \code{US-OR}

\if{html}{\out{<div class="sourceCode r">}}\preformatted{us_or_models <- dplyr::filter(
    allometric_models,
    purrr::map_lgl(region, ~ "US-OR" \%in\% .),
)

nrow(us_or_models)
#> [1] 498
}\if{html}{\out{</div>}}

We can see that 498 allometric models are defined for the
state of Oregon, US.
}

