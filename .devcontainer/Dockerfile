# Use Rocker's official R base image (already includes R)
FROM rocker/r-base:latest

# Install required R packages
RUN R -e "install.packages(c('languageserver', 'magrittr', 'functiondepends', 'glue', 'visNetwork', 'htmlwidgets', 'knitr', 'rmarkdown', 'testthat'), repos='https://cloud.r-project.org')"
