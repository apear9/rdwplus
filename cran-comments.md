# CRAN submission 28-11-2019

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