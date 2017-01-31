FROM nginx

MAINTAINER chris@datalinks.nl

ENV KUBECTL_VERSION 1.4.4
ENV AZURE_CLI_VERSION 0.1.0b8

WORKDIR /opt/ 

RUN apt-get update
RUN apt-get -y install nodejs-legacy
RUN apt-get -y install npm
RUN npm install express
RUN npm install socket.io
RUN npm install redis
RUN npm install serve-static
RUN npm install system-sleep



COPY src /opt/

CMD ["node","index.js"]
