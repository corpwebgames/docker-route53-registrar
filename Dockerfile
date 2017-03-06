FROM debian:jessie

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get install -y wget curl --no-install-recommends && rm -rf /var/lib/apt/lists/* && \
	wget https://github.com/jwilder/docker-gen/releases/download/0.7.3/docker-gen-linux-amd64-0.7.3.tar.gz && \
	tar xvzf docker-gen-linux-amd64-0.7.3.tar.gz -C /usr/local/bin && \
	rm docker-gen-linux-amd64-0.7.3.tar.gz

RUN wget https://github.com/barnybug/cli53/releases/download/0.8.7/cli53-linux-amd64 \
	&& mv cli53-linux-amd64 /usr/local/bin/cli53 \
	&& chmod +x /usr/local/bin/cli53

ADD cli53routes.tmpl /app/cli53routes.tmpl

ENV DOCKER_HOST=unix:///tmp/docker.sock

CMD /usr/local/bin/docker-gen -watch -notify "chmod +x /tmp/cli53routes && /bin/sh /tmp/cli53routes" -notify-output /app/cli53routes.tmpl /tmp/cli53routes
