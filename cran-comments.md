
## Test environments
* Local: Windows 11, R 4.4.2 via Posit Workbench

## R CMD check results
* There were no ERRORs or WARNINGs, except:

 - WARNING: ‘qpdf’ is needed for checks on size reduction of PDFs
    → This is a known optional dependency and does not affect package functionality.

* There was one NOTE:
 - "unable to verify current time"
    → This is due to system time settings and can be safely ignored.

## Comments
This is the first submission of the `funcMapper` package to CRAN.

The package provides a tool for visualising user-defined function dependencies within an R script. It is particularly useful for:
- Developers onboarding into a new codebase
- Teams collaborating on R projects
- Developers handing over projects

The main function, `funcMapper()`, generates an interactive HTML map of function relationships using `visNetwork`. It wraps the target script, traces user-defined functions recursively, and highlights the root script in red.

All examples, documentation, and tests have been verified locally.
