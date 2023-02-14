FROM rocker/r-ver:4.2.2

ARG WHEN

RUN mkdir /home/analysis

RUN R -e "options(repos = \
  list(CRAN = 'http://mran.revolutionanalytics.com/snapshot/${WHEN}')); \
  install.packages('tidyverse'); \
  install.packages('mongolite'); \
  install.packages('ggplot2')"

COPY MongoDB_data_analysis.R /home/analysis/MongoDB_data_analysis.R

CMD R -e "source('/home/analysis/MongoDB_data_analysis.R')"
