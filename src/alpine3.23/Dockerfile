FROM alpine:3.23 AS builder

ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_PLUGINS_MANAGER_VERSION="1.10"
# SHA512 checksums for integrity verification
ENV JMETER_SHA512="5978a1a35edb5a7d428e270564ff49d2b1b257a65e17a759d259a9283fc17093e522fe46f474a043864aea6910683486340706d745fcdf3db1505fd71e689083"
ENV JMETER_PLUGINS_MANAGER_SHA512="38af806a7c78473c032ba93c7a2e522674871f01616985a0b0522483977d58afdc444d18bd5590b8036c344ccf11d2fe61be807501d5edb6d4bdebc9050c43ae"

RUN apk add --no-cache curl \
    # Download JMeter
    && curl -L https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -o /tmp/jmeter.tgz \
    # Verify JMeter checksum
    && echo "${JMETER_SHA512}  /tmp/jmeter.tgz" | sha512sum -c - \
    && tar -xvf /tmp/jmeter.tgz -C /opt \
    # Download JMeter Plugins Manager
    && curl -L https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar -o ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar \
    # Verify Plugins Manager checksum
    && echo "${JMETER_PLUGINS_MANAGER_SHA512}  ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar" | sha512sum -c - \
    && rm -rf ${JMETER_HOME}/docs ${JMETER_HOME}/printable_docs /tmp/jmeter.tgz

FROM alpine:3.23

LABEL version="5.6.3"
LABEL description="An Alpine based docker image contains Apache JMeter GUI to configure scenario. Enable connect container with browser."
LABEL maintainer="3856350+guitarrapc@users.noreply.github.com"

ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV PATH=${JMETER_BIN}:$PATH
ENV DISPLAY=":99"

# Install minimal packages
RUN apk add --no-cache \
    ca-certificates bash fluxbox xterm x11vnc xvfb ttf-dejavu supervisor openjdk11-jre novnc \
    && ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html \
    && rm -rf /var/cache/apk/*

COPY --from=builder /opt/apache-jmeter-${JMETER_VERSION} /opt/apache-jmeter-${JMETER_VERSION}

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
