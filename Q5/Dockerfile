FROM ubuntu:latest
RUN apt-get update && apt-get install -y bash
COPY q5_script.sh /usr/local/bin/
COPY Q5_test.csv /data/
WORKDIR /data
