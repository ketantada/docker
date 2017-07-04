FROM ubuntu:16.04
ARG ssh_prv_key
RUN apt-get update
RUN apt-get install -y git nginx python-pip pgpool2 libpq-dev python-dev lzma-dev liblzma-dev libxml2-dev libpq-dev libxslt-dev python-virtualenv redis-tools postgresql-client

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts
# Add the keys and set permissions
RUN echo $ssh_prv_key +"aaa"
RUN echo "$ssh_prv_key" > /root/.ssh/deploykey && \
    chmod 600 /root/.ssh/deploykey

RUN echo "Host github.com \n IdentitiesOnly yes \n IdentityFile /root/.ssh/deploykey" >> /root/.ssh/config

RUN git clone git@github.com:plivo/plivocloud.git /plivocloud

WORKDIR /plivocloud

RUN virtualenv -p /usr/bin/python2 ./venv
RUN . venv/bin/activate

ADD requirements.txt /plivocloud/
RUN pip install -r requirements.txt
ADD . /plivocloud/

