FROM ubuntu:12.04

ENV KIBANA_VER 4.0.2

RUN \
	apt-get update && apt-get -y upgrade && \
	apt-get -y install curl && \
	apt-get -y install host

RUN \
	curl -o /opt/kibana-${KIBANA_VER}-linux-x64.tar.gz https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VER}-linux-x64.tar.gz && \
	cd /opt/ && \
	tar zxvf kibana-${KIBANA_VER}-linux-x64.tar.gz && \
	rm -rf kibana-${KIBANA_VER}-linux-x64.tar.gz && \
	ln -s kibana-${KIBANA_VER}-linux-x64 kibana

# Install Consul-Template
ENV CT_VER 0.9.0
ENV CT_NAME consul-template_${CT_VER}_linux_amd64
ADD https://github.com/hashicorp/consul-template/releases/download/v${CT_VER}/${CT_NAME}.tar.gz /tmp/${CT_NAME}.tgz
RUN \
	cd /tmp/ &&\
	tar -zvxf /tmp/${CT_NAME}.tgz && \
	rm /tmp/${CT_NAME}.tgz && \
	mv /tmp/${CT_NAME}/consul-template /bin/consul-template && \
	rm -rf /tmp/${CT_NAME}
ENV CONSUL_HOST consul.service.consul

COPY conf /conf
COPY templates /templates

RUN \
	ln -fs /conf/kibana.yml /opt/kibana/config/kibana.yml

COPY start /bin/start

EXPOSE 5601

ENTRYPOINT ["/bin/start"]

CMD ["/opt/kibana/bin/kibana"]