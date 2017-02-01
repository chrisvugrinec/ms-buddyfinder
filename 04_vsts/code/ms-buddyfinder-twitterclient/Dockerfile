FROM node

MAINTAINER chris@datalinks.nl

ENV KUBECTL_VERSION 1.4.4
ENV AZURE_CLI_VERSION 0.1.0b8

WORKDIR /opt/ 

RUN npm update
RUN npm install express
RUN npm install socket.io
RUN npm install redis
RUN npm -g install swagger
RUN npm install swagger-express-mw


COPY api /opt/api/
COPY app.js /opt/
COPY config  /opt/config/
COPY package.json /opt/
COPY test /opt/test/

CMD ["swagger","project","start"]
