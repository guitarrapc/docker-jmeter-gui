FROM alpine:3.23 as builder

ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}

RUN apk add --no-cache curl \
    && curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/jmeter.tgz \
    && tar -xvf /tmp/jmeter.tgz -C /opt \
    && curl -L https://jmeter-plugins.org/get/ > ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar \
    && rm -rf ${JMETER_HOME}/docs ${JMETER_HOME}/printable_docs

FROM alpine:3.23

LABEL version="5.6.3"
LABEL description="An Alpine based docker image contains Apache JMeter GUI to configure scenario. Enable connect container with browser via noVNC."
LABEL maintainer="3856350+guitarrapc@users.noreply.github.com"

ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV JMETER_PLUGINS_MANAGER_VERSION="1.10"
ENV PATH=${JMETER_BIN}:$PATH
ENV DISPLAY=":99"
ENV NOVNC_VERSION="1.5.0"

# Install minimal packages
RUN apk add --no-cache \
    wget ca-certificates openjdk11-jre \
    fluxbox xterm x11vnc xvfb ttf-dejavu supervisor \
    && rm -rf /var/cache/apk/*

# Install noVNC
RUN mkdir -p /opt/noVNC/utils/websockify \
    && wget -qO- https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar xz --strip 1 -C /opt/noVNC \
    && wget -qO- https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar xz --strip 1 -C /opt/noVNC/utils/websockify \
    && ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Configure VNC
RUN mkdir -p /root/.vnc \
    && echo '#!/bin/sh' > /root/.vnc/xstartup \
    && echo 'fluxbox &' >> /root/.vnc/xstartup \
    && echo 'jmeter -Jjmeter.laf=CrossPlatform' >> /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

COPY --from=builder /opt/apache-jmeter-${JMETER_VERSION} /opt/apache-jmeter-${JMETER_VERSION}

# Configure supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

WORKDIR /root

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
