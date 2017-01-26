FROM logstash
MAINTAINER chvugrin@microsoft.com

# Logstash config
COPY config/logstash.conf /logstash/config/logstash.conf

CMD ["-f","/logstash/config/logstash.conf"]
