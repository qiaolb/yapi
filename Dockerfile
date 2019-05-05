FROM node:lts-alpine

ARG YAPI_VERSION=1.7.0

RUN npm install -g yapi-cli \
    && apk update && apk add --no-cache mongodb make python git \
    && mkdir /yapi && cd /yapi  \
    && wget https://github.com/YMFE/yapi/archive/v$YAPI_VERSION.tar.gz \
    && tar -zxf *.gz \
    && rm -f *.gz \
    && cd /yapi/yapi-$YAPI_VERSION \
    && npm install && npm install -g node-gyp

WORKDIR /yapi/yapi-$YAPI_VERSION

#ENTRYPOINT ["node"]
#CMD ["vendors/server/app.js"]
EXPOSE 27017
EXPOSE 3000
COPY config.json /yapi/config.json

CMD mongod --fork --logpath /var/log/mongodb.log && [ ! -e /data/db/yapiInit.lock ] && npm run install-server && touch /data/db/yapiInit.lock; npm run start
