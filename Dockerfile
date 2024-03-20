FROM docker.io/debian:bullseye

RUN useradd sam -m

COPY --chmod=0555 ./etc/clc.sh /usr/local/bin/clc
    
RUN \
    apt-get update && \
    apt-get install -y \
        python3 \
        python3-venv \
        openjdk-17-jdk-headless \
        maven \
        curl \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists && \
    true

USER sam

WORKDIR /home/sam
        
RUN \
    curl -L -o hazelcast.tar.gz https://github.com/hazelcast/hazelcast/releases/download/v5.3.6/hazelcast-5.3.6.tar.gz &&\
    tar xf hazelcast.tar.gz &&\
    rm hazelcast.tar.gz
    
RUN \
    curl -L -o install.sh https://hazelcast.com/clc/install.sh &&\
    bash install.sh && \
    rm install.sh
    
ENV HZ_PHONE_HOME_ENABLED=false

RUN $HOME/.hazelcast/bin/clc config add default

ENTRYPOINT [ "hazelcast-5.3.6/bin/hz", "start" ]