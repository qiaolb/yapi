FROM node:11-alpine

RUN npm install -g yapi-cli \
    && apk update && apk add --no-cache make python git

WORKDIR /my-yapi

ENTRYPOINT ["node"]
CMD ["vendors/server/app.js"]
