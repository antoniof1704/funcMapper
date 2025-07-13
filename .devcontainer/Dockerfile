# Use Rocker's official R base image (includes R preinstalled)
FROM rocker/r-base:latest

# Install Git and system dependencies for devtools and R packages
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    locales \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    build-essential \
    libfontconfig1-dev && \
    locale-gen en_US.UTF-8 && \
    apt-get clean

# Install R packages including devtools
RUN R -e "install.packages(c(\
  'devtools', \
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
