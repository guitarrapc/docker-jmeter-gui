FROM alpine:edge

LABEL version="5.3"
LABEL description="An Alpine based docker image contains Apache JMeter GUI to configure scenario.\
    Enable connect container with XServer, xRDP and vnc."
LABEL maintainer="3856350+guitarrapc@users.noreply.github.com"

STOPSIGNAL SIGKILL
ENV JMETER_VERSION "5.3"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN ${JMETER_HOME}/bin
ENV PATH ${JMETER_BIN}:$PATH
ENV DISPLAY=":99" \
    RESOLUTION="1366x768x24" \
    PASS="root"

RUN  echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache curl xfce4-terminal xvfb x11vnc xfce4 openjdk8-jre bash xrdp \
    && curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz > /tmp/jmeter.tgz \
    && tar -xvf /tmp/jmeter.tgz -C /opt \
    && rm /tmp/jmeter.tgz \
    && curl -L https://jmeter-plugins.org/get/ > /opt/apache-jmeter-${JMETER_VERSION}/lib/ext/jmeter-plugins-manager.jar

RUN x11vnc -storepasswd ${PASS} /etc/x11vnc.pass
RUN echo "[Globals]" > /etc/xrdp/xrdp.ini \
    && echo "bitmap_cache=true" >> /etc/xrdp/xrdp.ini \
    && echo "bitmap_compression=true" >> /etc/xrdp/xrdp.ini \
    && echo "autorun=jmeter" >> /etc/xrdp/xrdp.ini \
    && echo "port=3389" >> /etc/xrdp/xrdp.ini \
    && echo "[jmeter]" >> /etc/xrdp/xrdp.ini \
    && echo "name=jmeter" >> /etc/xrdp/xrdp.ini \
    && echo "lib=libvnc.so" >> /etc/xrdp/xrdp.ini \
    && echo "ip=localhost" >> /etc/xrdp/xrdp.ini \
    && echo "port=5900" >> /etc/xrdp/xrdp.ini \
    && echo "username=root" >> /etc/xrdp/xrdp.ini \
    && echo "password=${PASS}" >> /etc/xrdp/xrdp.ini

EXPOSE 5900
EXPOSE 3389

WORKDIR /root

CMD ["bash", "-c", "rm -f /tmp/.X99-lock && rm -f /var/run/xrdp.pid\
    && nohup bash -c \"/usr/bin/Xvfb :99 -screen 0 ${RESOLUTION} -ac +extension GLX +render -noreset && export DISPLAY=99 > /dev/null 2>&1 &\"\
    && nohup bash -c \"startxfce4 > /dev/null 2>&1 &\"\
    && nohup bash -c \"x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :99 -forever -bg -nopw -rfbport 5900 -rfbauth /etc/x11vnc.pass > /dev/null 2>&1\"\
    && nohup bash -c \"xrdp > /dev/null 2>&1\"\
    && nohup bash -c \"jmeter -Jjmeter.laf=CrossPlatform > /dev/null 2>&1 &\"\
    && tail -f /dev/null"]
