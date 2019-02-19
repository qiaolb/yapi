FROM node:lts-alpine

RUN npm install -g yapi-cli \
    && apk update && apk add --no-cache mongodb make python git \
    && mkdir /yapi && cd /yapi  \
    && curl -LO https://github.com/YMFE/yapi/archive/v1.5.2.tar.gz \
    && tar -zxvf *.gz 

WORKDIR /yapi/yapi-1.5.2

#ENTRYPOINT ["node"]
#CMD ["vendors/server/app.js"]
EXPOSE 27017
EXPOSE 3000
COPY config.json /app/yapi/config.json

CMD ["mongod"]
