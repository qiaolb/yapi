FROM node:lts-buster-slim

ARG YAPI_VERSION=1.9.1

#RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y wget gnupg make python git  \
    && wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -  \
    && echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list  \
    && apt-get update && apt-get install -y mongodb-org \
    && mkdir /yapi && cd /yapi  \
    && wget https://github.com/YMFE/yapi/archive/v$YAPI_VERSION.tar.gz \
    && tar -zxf *.gz \
    && rm -f *.gz \
    && cd /yapi/yapi-$YAPI_VERSION \
    && rm -f .npmrc \
    && npm install

WORKDIR /yapi/yapi-$YAPI_VERSION

#ENTRYPOINT ["node"]
#CMD ["vendors/server/app.js"]
EXPOSE 27017
EXPOSE 3000
COPY config.json /yapi/config.json

CMD mongod --fork --logpath /var/log/mongodb.log && [ ! -e /data/db/yapiInit.lock ] && npm run install-server && touch /data/db/yapiInit.lock; npm run start
