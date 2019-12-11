FROM node:lts-alpine3.9

ARG YAPI_VERSION=1.8.5

RUN apk update \
    && apk add --no-cache --virtual curldeps gcc make g++ autoconf \
    && apk add --no-cache mongodb python git \
    && npm install -g yapi-cli \
    && mkdir /yapi && cd /yapi  \
    && wget https://github.com/YMFE/yapi/archive/v$YAPI_VERSION.tar.gz \
    && tar -zxf *.gz \
    && rm -f *.gz \
    && cd /yapi/yapi-$YAPI_VERSION \
    && npm install && npm install -g node-gyp \
    && apt delete curldeps

WORKDIR /yapi/yapi-$YAPI_VERSION

#ENTRYPOINT ["node"]
#CMD ["vendors/server/app.js"]
EXPOSE 27017
EXPOSE 3000
COPY config.json /yapi/config.json

CMD mongod --fork --logpath /var/log/mongodb.log && [ ! -e /data/db/yapiInit.lock ] && npm run install-server && touch /data/db/yapiInit.lock; npm run start
