FROM ubuntu:24.04

LABEL version="5.6.3"
LABEL description="An Ubuntu based docker image contains Apache JMeter GUI to configure scenario.\
    Enable connect container with VNC and RDP."
LABEL maintainer="3856350+guitarrapc@users.noreply.github.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV JMETER_PLUGINS_MANAGER_VERSION="1.10"
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
    && rm -rf ${JMETER_HOME}/docs ${JMETER_HOME}/printable_docs
RUN wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar

# Configure VNC
RUN x11vnc -storepasswd ${PASS} /etc/x11vnc.pass

# Set root password for RDP login
RUN echo "root:${PASS}" | chpasswd

# Configure RDP
RUN echo "[Globals]" > /etc/xrdp/xrdp.ini \
    && echo "bitmap_cache=true" >> /etc/xrdp/xrdp.ini \
    && echo "bitmap_compression=true" >> /etc/xrdp/xrdp.ini \
    && echo "autorun=jmeter" >> /etc/xrdp/xrdp.ini \
    && echo "port=3389" >> /etc/xrdp/xrdp.ini \
    && echo "" >> /etc/xrdp/xrdp.ini \
    && echo "[jmeter]" >> /etc/xrdp/xrdp.ini \
    && echo "name=jmeter" >> /etc/xrdp/xrdp.ini \
    && echo "lib=libvnc.so" >> /etc/xrdp/xrdp.ini \
    && echo "ip=127.0.0.1" >> /etc/xrdp/xrdp.ini \
    && echo "port=5900" >> /etc/xrdp/xrdp.ini \
    && echo "username=na" >> /etc/xrdp/xrdp.ini \
    && echo "password=ask" >> /etc/xrdp/xrdp.ini

EXPOSE 5900 3389

WORKDIR /root

CMD ["bash", "-c", "rm -f /tmp/.X99-lock /var/run/xrdp.pid /var/run/xrdp-sesman.pid \
    && /usr/bin/Xvfb ${DISPLAY} -screen 0 ${RESOLUTION} -ac +extension GLX +render -noreset & \
    sleep 3 \
    && fluxbox & \
    sleep 2 \
    && jmeter -Jjmeter.laf=CrossPlatform & \
    sleep 3 \
    && x11vnc -xkb -noxrecord -noxfixes -noxdamage -display ${DISPLAY} -forever -rfbport 5900 -rfbauth /etc/x11vnc.pass -shared & \
    sleep 2 \
    && xrdp-sesman & \
    sleep 1 \
    && xrdp --nodaemon"]
