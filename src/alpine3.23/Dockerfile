FROM alpine:3.23.2 as builder

ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}

RUN apk add --no-cache curl \
    && curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/jmeter.tgz \
    && tar -xvf /tmp/jmeter.tgz -C /opt \
    && curl -L https://jmeter-plugins.org/get/ > ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar \
    && rm -rf ${JMETER_HOME}/docs ${JMETER_HOME}/printable_docs

FROM alpine:3.23.2

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

COPY --from=builder /opt/apache-jmeter-${JMETER_VERSION} /opt/apache-jmeter-${JMETER_VERSION}

RUN  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache xterm xvfb x11vnc fluxbox openjdk8-jre bash ttf-dejavu \
    && x11vnc -storepasswd ${PASS} /etc/x11vnc.pass \
    && mkdir -p /root/.fluxbox && echo "session.screen0.workspaces: 1" > /root/.fluxbox/init

EXPOSE 5900

WORKDIR /root

CMD ["bash", "-c", "rm -f /tmp/.X99-lock \
    && /usr/bin/Xvfb :99 -screen 0 ${RESOLUTION} -ac +extension GLX +render -noreset & \
    sleep 2 \
    && fluxbox & \
    sleep 2 \
    && x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :99 -forever -bg -rfbport 5900 -rfbauth /etc/x11vnc.pass \
    && sleep 2 \
    && jmeter -Jjmeter.laf=CrossPlatform & \
    tail -f /dev/null"]
