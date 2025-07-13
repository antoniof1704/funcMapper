# Base image
FROM mcr.microsoft.com/devcontainers/base:ubuntu

# Install R and basic tools
RUN apt-get update && \
    apt-get install -y r-base curl locales && \
    locale-gen en_US.UTF-8 && \
    R -e "install.packages('languageserver', 'magrittr', 'functiondepends', 'glue', 'visNetwork', 'htmlwidgets', 'knitr', 'rmarkdown', 'testthat', repos='https://cloud.r-project.org')" && \
    apt-get clean
