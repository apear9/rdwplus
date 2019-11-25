# CRAN submission 25-11-2019

## Changes

THIS IS A RESUBMISSION. Here are the changes that were made in accordance with CRAN maintainers' requests:

In the DESCRIPTION file:

* Shortened title to under 65 characters. Now it is 34 characters long.
* Changed citation style to authors (year) <doi:...>

In Rd files:

* Added executable examples.

Note that although the request was to "Please add small executable examples in your Rd-files to illustrate the use of the exported function but also enable automatic testing", we have set our examples to not run. This is because almost all the examples require an installation of GRASS GIS 7.6, which CRAN does not have. Allowing the examples to run would simply mean that they all report errors due to the missing GRASS GIS installation. There is no point in that.

## Test environments

## R CMD check results

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