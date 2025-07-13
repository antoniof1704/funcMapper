# Use Rocker's official R base image (includes R preinstalled)
FROM rocker/r-base:latest

# Install Git and any other needed system dependencies
RUN apt-get update && \
    apt-get install -y git curl locales && \
    locale-gen en_US.UTF-8 && \
    apt-get clean

# Install R packages
RUN R -e "install.packages(c(\
  'languageserver', \
  'magrittr', \
  'functiondepends', \
  'glue', \
  'visNetwork', \
  'htmlwidgets', \
  'knitr', \
  'rmarkdown', \
  'testthat'\
), repos='https://cloud.r-project.org')"
