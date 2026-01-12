FROM ubuntu:24.04 AS builder

ARG TARGETARCH

ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_PLUGINS_MANAGER_VERSION="1.10"
# SHA512 checksums for integrity verification
ENV JMETER_SHA512="5978a1a35edb5a7d428e270564ff49d2b1b257a65e17a759d259a9283fc17093e522fe46f474a043864aea6910683486340706d745fcdf3db1505fd71e689083"
ENV JMETER_PLUGINS_MANAGER_SHA512="38af806a7c78473c032ba93c7a2e522674871f01616985a0b0522483977d58afdc444d18bd5590b8036c344ccf11d2fe61be807501d5edb6d4bdebc9050c43ae"

RUN apt-get update \
    && apt-get install -y --no-install-recommends wget ca-certificates \
    # Download JMeter
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz -O /tmp/jmeter.tgz \
    # Verify JMeter checksum
    && echo "${JMETER_SHA512}  /tmp/jmeter.tgz" | sha512sum -c - \
    && tar -xzf /tmp/jmeter.tgz -C /opt \
    # Download JMeter Plugins Manager
    && wget https://repo1.maven.org/maven2/kg/apc/jmeter-plugins-manager/${JMETER_PLUGINS_MANAGER_VERSION}/jmeter-plugins-manager-${JMETER_PLUGINS_MANAGER_VERSION}.jar -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar \
    # Verify Plugins Manager checksum
    && echo "${JMETER_PLUGINS_MANAGER_SHA512}  ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar" | sha512sum -c - \
    && rm -rf ${JMETER_HOME}/docs ${JMETER_HOME}/printable_docs /tmp/jmeter.tgz

FROM ubuntu:24.04

ARG TARGETARCH

LABEL version="5.6.3"
LABEL description="An Ubuntu based docker image contains Apache JMeter GUI to configure scenario. Enable connect container with browser."
LABEL maintainer="3856350+guitarrapc@users.noreply.github.com"

ENV DEBIAN_FRONTEND=noninteractive
ENV KASMVNC_VERSION="1.4.0"
ENV JMETER_VERSION="5.6.3"
ENV JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN=${JMETER_HOME}/bin
ENV PATH=${JMETER_BIN}:$PATH
ENV DISPLAY=":99"

# Install minimal packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates fluxbox xterm openjdk-11-jre wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install KasmVNC
RUN wget https://github.com/kasmtech/KasmVNC/releases/download/v${KASMVNC_VERSION}/kasmvncserver_jammy_${KASMVNC_VERSION}_${TARGETARCH}.deb -O /tmp/kasmvnc.deb \
    && apt-get update \
    && apt-get install -y --no-install-recommends /tmp/kasmvnc.deb \
    && rm /tmp/kasmvnc.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/apache-jmeter-${JMETER_VERSION} /opt/apache-jmeter-${JMETER_VERSION}

# Configure KasmVNC
RUN mkdir -p /root/.vnc \
    && echo '#!/bin/sh' > /root/.vnc/xstartup \
    && echo 'fluxbox &' >> /root/.vnc/xstartup \
    && echo 'jmeter -Jjmeter.laf=CrossPlatform' >> /root/.vnc/xstartup \
    && chmod +x /root/.vnc/xstartup

COPY kasmvnc.yaml /root/.vnc/kasmvnc.yaml

EXPOSE 8080

WORKDIR /root

CMD ["bash", "-c", "echo '2' | vncserver ${DISPLAY} -DisableBasicAuth -select-de manual -fg"]
