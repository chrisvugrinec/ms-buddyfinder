FROM cvugrinec/swagger-example:1.0

MAINTAINER chris@datalinks.nl

ENV KUBECTL_VERSION 1.4.4
ENV AZURE_CLI_VERSION 0.1.0b8

WORKDIR /opt/ 


COPY api /opt/api/
COPY app.js /opt/
COPY config  /opt/config/
COPY test /opt/test/
COPY package.json /opt/

CMD ["swagger","project","start"]
