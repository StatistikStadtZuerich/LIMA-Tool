# use the same R version as in our development
FROM rocker/tidyverse:4.2.1

# install curl
RUN apt-get update
RUN apt-get install -y curl

COPY renv.lock ./renv.lock

# install latest version of rsconnect, and also of its dependency, renv
# latest version of rsconnect needed for shinyapps.io (version going with R 4.2.1 is too old)
# i.e. rsconnect could probably be installed normally with a later R version
RUN Rscript -e "install.packages('pak')"
RUN Rscript -e "pak::pkg_install('rstudio/renv')"
RUN Rscript -e "pak::pkg_install('rstudio/rsconnect')"

RUN Rscript -e "renv::status()"

RUN Rscript -e "renv::restore()"

RUN Rscript -e "renv::status()"

#RUN Rscript -e "pak::pkg_install('mitchelloharawild/icons')"
#RUN Rscript -e "pak::pkg_install('StatistikStadtZuerich/zuericssstyle')"
#RUN Rscript -e "pak::pkg_install('StatistikStadtZuerich/zuericolors')"
