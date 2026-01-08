FROM ubuntu:24.04

LABEL version="5.6.3"
LABEL description="An Ubuntu based docker image contains Apache JMeter GUI to configure scenario.\
    Enable connect container with VNC and RDP."
LABEL maintainer="3856350+guitarrapc@users.noreply.github.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV PATH=${JMETER_BIN}:$PATH
ENV DISPLAY=":99" \
    RESOLUTION="1366x768x24" \
    PASS="root"

# Install minimal packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    wget ca-certificates \
    xvfb x11vnc \
    xrdp xorgxrdp \
    fluxbox xterm \
    openjdk-11-jre \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download JMeter
RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/jmeter.tgz \
    && tar -xzf /tmp/jmeter.tgz -C /opt \
    && rm /tmp/jmeter.tgz \
    && rm -rf ${JMETER_HOME}/docs ${JMETER_HOME}/printable_docs \
    && wget https://jmeter-plugins.org/get/ -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar

# Configure VNC
RUN x11vnc -storepasswd ${PASS} /etc/x11vnc.pass

# Set root password for RDP login
RUN echo "root:${PASS}" | chpasswd

# Configure RDP
RUN mkdir -p /root/.fluxbox \
    && echo "session.screen0.workspaces: 1" > /root/.fluxbox/init \
    && echo '#!/bin/bash' > /etc/xrdp/startwm.sh \
    && echo 'export PATH=/opt/apache-jmeter-5.6.3/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin' >> /etc/xrdp/startwm.sh \
    && echo 'export DISPLAY=${DISPLAY:-:10}' >> /etc/xrdp/startwm.sh \
    && echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> /etc/xrdp/startwm.sh \
    && echo '/usr/bin/fluxbox &' >> /etc/xrdp/startwm.sh \
    && echo '/opt/apache-jmeter-5.6.3/bin/jmeter -Jjmeter.laf=CrossPlatform' >> /etc/xrdp/startwm.sh \
    && chmod +x /etc/xrdp/startwm.sh

EXPOSE 5900 3389

WORKDIR /root

CMD ["bash", "-c", "rm -f /tmp/.X99-lock /var/run/xrdp.pid /var/run/xrdp-sesman.pid \
    && /usr/bin/Xvfb :99 -screen 0 ${RESOLUTION} -ac +extension GLX +render -noreset & \
    sleep 2 \
    && fluxbox & \
    sleep 2 \
    && x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :99 -forever -bg -rfbport 5900 -rfbauth /etc/x11vnc.pass \
    && sleep 2 \
    && xrdp-sesman && xrdp --nodaemon & \
    sleep 2 \
    && DISPLAY=:99 jmeter -Jjmeter.laf=CrossPlatform & \
    tail -f /dev/null"]
