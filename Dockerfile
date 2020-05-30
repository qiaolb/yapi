FROM node:lts-buster-slim

ARG YAPI_VERSION=1.9.2
ARG BUILD_PACKAGES="wget make python build-essential"

RUN apt-get update && apt-get install -y gnupg $BUILD_PACKAGES  \
    && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -  \
    && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list  \
    && apt-get update && apt-get install -y mongodb-org \
    && mkdir /yapi && cd /yapi  \
    && wget https://github.com/YMFE/yapi/archive/v$YAPI_VERSION.tar.gz \
    && tar -zxf *.gz \
    && rm -f *.gz \
    && apt-get remove --purge -y $BUILD_PACKAGES && rm -rf /var/lib/apt/lists/* \
    && cd /yapi/yapi-$YAPI_VERSION \
    && npm install --production

#RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
#RUN apt-get update && apt-get install -y $BUILD_PACKAGES
#RUN mkdir /yapi
#COPY v$YAPI_VERSION.tar.gz /yapi/v$YAPI_VERSION.tar.gz
#RUN cd /yapi && tar -zxf *.gz
#COPY config.json /yapi/config.json
##RUN cd /yapi/yapi-$YAPI_VERSION && npm install --production --registry #https://registry.npm.taobao.org
#RUN apt-get remove --purge -y $BUILD_PACKAGES && rm -rf /var/lib/apt/lists/*

WORKDIR /yapi/yapi-$YAPI_VERSION

EXPOSE 27017
EXPOSE 3000
COPY config.json /yapi/config.json

CMD mongod --fork --logpath /var/log/mongodb.log && [ ! -e /data/db/yapiInit.lock ] && npm run install-server && touch /data/db/yapiInit.lock; npm run start
