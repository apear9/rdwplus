# CRAN submission 23-08-2023

This is an update. The purpose of this update is to change the main dependency from rgrass7 to rgrass, to resolve a documentation issue flowing on from a change to `roxygen2`, and also to remove any dependency on raster. 
This is the first submission of the updated package.

# Addressing correspondence from CRAN

Please note the following emails we have received from CRAN and our responses to the emails:

Regarding the documentation issue, we received the following email on 19 August, 2023. We have addressed this by making the change suggested.

"
Dear maintainer,

You have file 'rdwplus/man/rdwplus.Rd' with \docType{package}, likely
intended as a package overview help file, but without the appropriate
PKGNAME-package \alias as per "Documenting packages" in R-exts.

This seems to be the consequence of the breaking change

  Using @docType package no longer automatically adds a -package alias.
  Instead document _PACKAGE to get all the defaults for package
  documentation.

in roxygen2 7.0.0 (2019-11-12) having gone unnoticed, see
<https://github.com/r-lib/roxygen2/issues/1491>.

As explained in the issue, to get the desired PKGNAME-package \alias
back, you should either change to the new approach and document the new
special sentinel

  "_PACKAGE"

or manually add

  @aliases rdwplus-package

if remaining with the old approach.

Please fix in your master sources as appropriate, and submit a fixed
version of your package within the next few months.

Best,
-k
"

Regarding the deprecation of `rgrass7`, we received the following email on 24 May, 2023. We have removed the dependency on `rgrass7` and switched over to using `rgrass`. 

"Dear maintainer,

rdwplus will be affected when rgrass7 retires in October 2023, as a consequence of the retirement of rgdal (see https://r-spatial.org/r/2023/05/15/evolution4.html and reports linked from there). rgrass is the replacement for rgrass7, sso please update rdwplus to use it instead. Note that since September 2022, raster has used terra in place of rgdal to access GDAL functionality, as does rgrass.

Best wishes,

Roger
"

## Test environments

Install was tested using the rhub pacakge and the `check_for_cran()` function.

The test environments listed below were used:

* local Windows install, R4.3.1
* Windows Server 2022, R-devel, 64 bit
* Ubuntu Linux 20.04.1 LTS, R-release, GCC
* Fedora Linux, R-devel, clang, gfortran

## R CMD check results

There were no ERRORs or WARNINGs.

There were some NOTEs. 

The following NOTE appeared on all test environments:

```
Maintainer: 'Alan Pearse <arp320@uowmail.edu.au>'

New maintainer:
  Alan Pearse <arp320@uowmail.edu.au>
Old maintainer(s):
  Alan Pearse <apearse9@gmail.com>
```

This is fine: the maintainer is the same person but the email has been updated to reflect a new institutional affiliation.

On Windows Server 2022, R-devel, 64 bit, there were two additional NOTEs. The first is an empty note that is most likely ignorable:

```
* checking for detritus in the temp directory ... NOTE
```

The second is also most likely ignorable (see [R-hub issue #503](https://github.com/r-hub/rhub/issues/503)):

```
* checking for non-standard things in the check directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'
```

The following NOTE also appears on Fedora Linux, R-devel, clang, gfortran, and 	Ubuntu Linux 20.04.1 LTS, R-release, GCC:

```
* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
```

This is another issue that has been raised on the GitHub repo for rhub (see [R-hub issue #548](https://github.com/r-hub/rhub/issues/548)). It is most likely ignorable.

# CRAN submission 03-12-2019

THIS IS A RESUBMISSION. 

## Feedback from CRAN maintainer

"
Thanks,

Please omit the redundant "in R" from the title.

You have examples for unexported functions which cannot run in this way.
Please either add rdwplus::: to the function calls in the examples, omit
these examples or export these functions.
e.g.: get_distance.Rd, ...

\dontrun{} should only be used if the example really cannot be executed
(e.g. because of missing additional software, missing API keys, ...) by
the user. That's why wrapping examples in \dontrun{} adds the comment
("# Not run:") as a warning for the user.
Does not seem necessary in e.g. search_for_grass.Rd, ...
Please replace \dontrun with \donttest.

Please always make sure to reset to user's options (not default), wd or
par after you changed it in examples and vignettes.
e.g.: reclassify_streams.Rd, ...
oldpar <- par(mfrow = c(2,2))
...
par(oldpar)

Please ensure that your functions do not write by default or in your
examples/vignettes/tests in the user's home filespace (including the
package directory and getwd()). That is not allowed by CRAN policies.
Please only write/save files if the user has specified a directory in
the function themselves.
In your examples/vignettes/tests you can write to tempdir().

Please fix and resubmit.
"

## Changes and addressing comments

In the DESCRIPTION file:

* Removed the phrase 'in R' from the title

In Rd files:

* Unexported functions previously with examples (get_distance.R, report_mapset.R) have had their examples removed.
* \dontrun has been replaced with \donttest (search_for_grass.R because this takes a while to run) or removed altogether (e.g. toggle_silence.R, silence.R because there is no reason these cannot run)
* All examples where we set par() have been modified such that we no longer set par(). E.g. derive_flow.R, reclassify_streams.R.

Addressing the "[ensuring] that [our] functions do not write by default or in [our] examples/vignettes/tests in the user's home filespace. ...
Please only write/save files if the user has specified a directory in the function themselves" comment:

* in get_watershed.R, the user can set the argument `out` to write a raster wherever they please. By default no file is written. Therefore there is no issue with the above comment. I have adjusted the Rd file to better reflect this.
* in plot_GRASS.R, files are by default written to tempdir() which does not present a problem with the above. The function has an optional argument `out_x` which can be used to write out a file to the user's filespace in a location of their choosing if and only if that is what they want.
* in rasterise_stream.R, the function writes out a file to a user-specified location through the argument `out`. Therefore, in general, this does not violate CRAN policy. However, the example does violate this policy. I have set the example to write a file to tempdir() instead of in the default directory.
* in retrieve_vector.R, the example did indeed violate CRAN policy by writing out a file to a default directory. This has been changed to write out the file to tempdir(). Nothing in the way the function works in general violates CRAN policy.
* same deal for retrieve_raster.R
* same deal for snap_sites.R
* all functions whose examples were affected by the issue with rasterise_stream.R's, retrieve_vector/retrieve_raster.R's, and snap_sites.R's examples have had their examples changed.

In any case, the main modes of writing outputs as files in the user's filespace are the two functions retrieve_raster.R and retrieve_vector.R. These are functions the user must generally explicitly call, and in which the user can specify exactly where files are to be written.
Almost all other functions (with the exceptions addressed in the dot points above) only write to the GRASS dbase location. When initialising GRASS from R (done with a function `initGRASS` from the package `rgrass7`), the user must set this parameter or else it is set to tempdir() by default. Therefore, the user knows where these files are going.

Other minor changes:

* in toggle_silence.R, the example now uses TRUE and FALSE instead of T and F. Important because, now that the example runs, using T and F produce an error. 
* other minor adjustments to documentation and formatting styles as a result of updating my roxygen2 version to 7.0.2. 

## Test environments

* local Windows install, R 3.6.1
* Ubuntu Linux 16.04 (release)
* Fedora Linux (devel)
* Windows Server 2008 R2 SP1 (devel)

## R CMD check results

There were no ERRORs or WARNINGs.

Besides the NOTE "Maintainer: 'Alan Pearse <apearse9@gmail.com>'", there were no NOTEs.

## Downstream dependencies

There are no downstream dependencies. 

# CRAN submission 29-11-2019

THIS IS A RESUBMISSION. 

## Feedback from CRAN maintainer

"
Please shorten the title to a maximum of 65 characters.
Acronyms can be used on their own in the title as long as they are
explained in the description field.

Please write references in the form
authors (year) <doi:...>
authors (year) <arXiv:...>f
authors (year, ISBN:...)
or if those are not available: authors (year) <https:...>
with no space after 'doi:', 'arXiv:', 'https:' and angle brackets for
auto-linking.

Please add small executable examples in your Rd-files to illustrate the
use of the exported function but also enable automatic testing.

Please fix and resubmit, and document what was changed in the submission
comments.
"

## Changes

In the DESCRIPTION file:

* Shortened title to under 65 characters. Now it is 34 characters long.
* The acronym IDW-PLUS is now explained in the description field.
* Changed citation style to authors (year) <doi:...>

In Rd files:

* Added executable examples to exported functions.
* Minor adjustments to text throughout. 

Note that the request was 

"Please add small executable examples in your Rd-files to illustrate the use of the exported function but also enable automatic testing".

We have indeed written executable examples for our exported functions. These illustrate how to use our functions. 
However, on the 'automatic testing' note, we don't think this is possible. Very few of our functions can be run without a valid installation of GRASS GIS 7.6 on the user's computer. 
Not only that but the function get_flow_length will not execute without a GRASS add-on module called r.stream.distance that must be installed manually from inside GRASS. 
Similarly for the function fill_sinks with the GRASS add-on module r.hydrodem, and snap_sites with the module r.stream.snap. 
These reliances on the GRASS GIS add-on modules have been noted in the corresponding Rd files. 
CRAN checks performed on computers without GRASS GIS 7.6 will therefore always fail if we allow examples to be executed during CRAN checks and other testing. 
We tried to do CRAN checks on the testing environments listed below with the examples set to run and we came across this issue. 
To avoid this, we have set up the examples such that instructive code blocks are provided but are set only to run if R detects an instance of GRASS is running. 
Users can still execute the examples by pasting the code from the function help files into their consoles. We have tested on a local Windows 10 computer with R 3.6.1 that the examples run without error when GRASS is running. 

In functions:

* derive_streams had a previously unknown issue which we uncovered while writing and testing its example. It was missing an argument (dem) that needed to be passed to the GRASS module that it calls. This has now been added and the documentation for the function changed accordingly.
* changed the search string in search_for_grass
* the function report_mapset is no longer exported

## Test environments

* local Windows install, R 3.6.1
* Ubuntu Linux 16.04 (release)
* Fedora Linux (devel)
* Windows Server 2008 R2 SP1 (devel)

## R CMD check results

There were no ERRORs or WARNINGs.

Besides the NOTE "Maintainer: 'Alan Pearse <apearse9@gmail.com>'", there were no NOTEs.

## Downstream dependencies

There are no downstream dependencies. 

# Initial CRAN submission

## Test environments

* local OS X install, R 3.6.1
* local Windows install, R 3.6.1
* Ubuntu Linux 16.04 (release)
* Fedora Linux (devel)
* Windows Server 2008 R2 SP1 (devel)

## R CMD check results

There were no ERRORs or WARNINGs.

Besides the NOTE "Maintainer: 'Alan Pearse <apearse9@gmail.com>'", there were no NOTEs.

## Downstream dependencies

There are no downstream dependencies. 