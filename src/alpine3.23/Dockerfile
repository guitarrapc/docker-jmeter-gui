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
    bash \
    wget \
    ca-certificates \
    fluxbox \
    xterm \
    x11vnc \
    xvfb \
    openjdk11-jre \
    perl-datetime \
    supervisor \
    git \
    python3 \
    py3-numpy \
    ttf-dejavu \
    fontconfig \
    dbus \
    dbus-x11 \
    mesa-gl \
    mesa-dri-gallium \
    libxrender \
    libxtst \
    libxi \
    && rm -rf /var/cache/apk/*

# Install noVNC
RUN mkdir -p /opt/noVNC/utils/websockify \
    && wget -qO- https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar xz --strip 1 -C /opt/noVNC \
    && wget -qO- https://github.com/novnc/websockify/archive/v0.12.0.tar.gz | tar xz --strip 1 -C /opt/noVNC/utils/websockify \
    && ln -s /opt/noVNC/vnc.html /opt/noVNC/index.html

# Download JMeter
RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/jmeter.tgz \
    && tar -xzf /tmp/jmeter.tgz -C /opt \
    && rm /tmp/jmeter.tgz \
    && rm -rf ${JMETER_HOME}/docs ${JMETER_HOME}/printable_docs
RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar

# Configure VNC
RUN mkdir -p /root/.vnc \
    && echo '#!/bin/sh' > /root/.vnc/xstartup \
    && echo 'fluxbox &' >> /root/.vnc/xstartup \
    && echo 'jmeter -Jjmeter.laf=CrossPlatform' >> /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

# Configure supervisord
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

WORKDIR /root

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
