FROM rocker/r-base:latest

# Install Git and system dependencies for devtools and related packages
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
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    build-essential && \
    locale-gen en_US.UTF-8 && \
    apt-get clean

# Install R packages in stages to avoid dependency chain breakage
RUN R -e "install.packages(c('pkgdown'), repos='https://cloud.r-project.org')"

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
