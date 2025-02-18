# Dockerfile for Q5 R container
FROM r-base:latest

# Optionally install system dependencies
RUN apt-get update && apt-get install -y

# Copy the R script into the container
COPY analyze.R /analyze.R
COPY /Q5_test.csv /data/Q5_test.csv

# Set the working directory
WORKDIR /

# Pre-install dplyr & ggplot2 so it doesn't reinstall every run
# (Optional, since we also do install.packages in analyze.R)
RUN R -e "install.packages(c('dplyr','ggplot2'), repos='http://cran.us.r-project.org')"


CMD ["/bin/bash"]