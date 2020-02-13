FROM rocker/verse:3.6.2

COPY R/ /home/rstudio/legacy/R

RUN Rscript /home/rstudio/legacy/R/requirements.R
