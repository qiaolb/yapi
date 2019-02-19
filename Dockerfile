FROM node:lts-alpine

RUN npm install -g yapi-cli \
    && apk update && apk add --no-cache mongodb make python git

WORKDIR /my-yapi

#ENTRYPOINT ["node"]
#CMD ["vendors/server/app.js"]
CMD ["mongod"]
