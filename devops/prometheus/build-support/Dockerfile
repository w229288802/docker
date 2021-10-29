FROM golang
RUN wget https://github.com/prometheus/prometheus/releases/download/v2.29.1/prometheus-2.29.1.linux-amd64.tar.gz && \
    tar -xvf prometheus-2.29.1.linux-amd64.tar.gz
WORKDIR /go/prometheus-2.29.1.linux-amd64
COPY prometheus.yml /go/prometheus-2.29.1.linux-amd64/prometheus.yml
CMD ./prometheus --config.file=prometheus.yml --web.enable-lifecycle
