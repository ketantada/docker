FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -y git nginx python-pip pgpool2 libpq-dev python-dev lzma-dev liblzma-dev libxml2-dev libpq-dev libxslt-dev python-virtualenv redis-tools postgresql-client

 RUN mkdir /plivocloud
 WORKDIR /plivocloud

 RUN virtualenv -p /usr/bin/python2 ./venv
 RUN . venv/bin/activate

 ADD requirements.txt /plivocloud/
 RUN pip install -r requirements.txt
 ADD . /plivocloud/

