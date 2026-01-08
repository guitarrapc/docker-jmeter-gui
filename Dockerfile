FROM alpine:edge

LABEL version="5.6.3"
LABEL description="An Alpine based docker image contains Apache JMeter GUI to configure scenario.\
    Enable connect container with VNC."
LABEL maintainer="3856350+guitarrapc@users.noreply.github.com"

STOPSIGNAL SIGKILL
ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV PATH=${JMETER_BIN}:$PATH
ENV DISPLAY=":99" \
    RESOLUTION="1366x768x24" \
    PASS="root"

RUN  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache curl xfce4-terminal xvfb x11vnc xfce4 openjdk8-jre bash \
    && curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/jmeter.tgz \
    && tar -xvf /tmp/jmeter.tgz -C /opt \
    && rm /tmp/jmeter.tgz \
    && curl -L https://jmeter-plugins.org/get/ > /opt/apache-jmeter-${JMETER_VERSION}/lib/ext/jmeter-plugins-manager.jar

RUN x11vnc -storepasswd ${PASS} /etc/x11vnc.pass

EXPOSE 5900

WORKDIR /root

CMD ["bash", "-c", "rm -f /tmp/.X99-lock \
    && /usr/bin/Xvfb :99 -screen 0 ${RESOLUTION} -ac +extension GLX +render -noreset & \
    sleep 2 \
    && startxfce4 & \
    sleep 2 \
    && x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :99 -forever -bg -rfbport 5900 -rfbauth /etc/x11vnc.pass \
    && sleep 2 \
    && jmeter -Jjmeter.laf=CrossPlatform & \
    tail -f /dev/null"]
