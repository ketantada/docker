FROM ubuntu:16.04
ARG ssh_prv_key

# update & install
RUN apt-get update
RUN apt-get install -y git nginx python-pip pgpool2 libpq-dev python-dev lzma-dev liblzma-dev libxml2-dev libpq-dev libxslt-dev python-virtualenv redis-tools postgresql-client zsh 

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts
# Add the keys and set permissions
# RUN echo "$ssh_prv_key" > /root/.ssh/deploykey && \
#     chmod 600 /root/.ssh/deploykey
ADD deploykey_apiservice /root/.ssh/deploykey  
RUN chmod 600 /root/.ssh/deploykey

# Create ssh config
RUN echo "Host github.com \n IdentitiesOnly yes \n IdentityFile /root/.ssh/deploykey" >> /root/.ssh/config

# Clone the repository
RUN git clone git@github.com:plivo/plivocloud.git /opt/plivocloud

WORKDIR /opt/plivocloud

RUN virtualenv -p /usr/bin/python2 .
RUN . bin/activate

RUN pip install -r requirements.txt

EXPOSE 8000

WORKDIR /opt/plivocloud/plivo_cloud
RUN ln -s local_settings.py settings.py
RUN python manage.py runserver  < /dev/null > /tmp/console.log &
