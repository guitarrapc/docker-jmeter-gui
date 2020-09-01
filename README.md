![Docker Build](https://github.com/guitarrapc/docker-jmeter-gui/workflows/Docker%20Build/badge.svg) ![Docker Push](https://github.com/guitarrapc/docker-jmeter-gui/workflows/Docker%20Push/badge.svg) [![hub](https://img.shields.io/docker/pulls/guitarrapc/jmeter-gui.svg)](https://hub.docker.com/r/guitarrapc/jmeter-gui/)

# docker-jmeter-gui

Docker image for [Apache JMeter](http://jmeter.apache.org).
This Docker image run jmeter gui on container and user can connect via VNC or RDP.
Find Images of this repo on [Docker Hub](https://hub.docker.com/r/guitarrapc/jmeter-gui).

## Usage

run container

```shell
docker run -itd --rm -v ${WORK_DIR}/:/root/jmeter/ -p 5900:5900 -p 3390:3389 guitarrapc/jmeter-gui:latest
```

docker-compose (see sample)

```shell
docker-compose up
```

```yaml
version: "3"
services:
  web:
    image: guitarrapc/jmeter-gui:latest
    tty: true
    volumes:
      - ./scenario/:/root/jmeter/
    ports:
      - 5900:5900
      - 3390:3389
```

connect to container via VNC or RDP.

* vpc pass: `root`
* rdp pass: `root`

**RDP**

![image](https://user-images.githubusercontent.com/3856350/91890535-9a083700-ecca-11ea-877f-2a30a2c84d74.png)

> TIPS: if you cannot see password column, just type password and press ENTER key.

![image](https://user-images.githubusercontent.com/3856350/91892760-2d8f3700-ecce-11ea-9da4-089b2da50305.png)


**VNC**

![image](https://user-images.githubusercontent.com/3856350/91890592-ae4c3400-ecca-11ea-9b25-a9da712a7a93.png)

Jmeter GUI is already launched.

![image](https://user-images.githubusercontent.com/3856350/91890725-e489b380-ecca-11ea-984f-308a23d2144c.png)

Configure JMeter Scenario with GUI inside container.

![image](https://user-images.githubusercontent.com/3856350/91891086-5c57de00-eccb-11ea-824b-04e0c2b90d35.png)


Save Scenario's `.jmx` on mounted volume to share Scenario with Host OS, in this example `/root/jmeter`.

![image](https://user-images.githubusercontent.com/3856350/91890909-20bd1400-eccb-11ea-8d18-5846bdd7fe4b.png)
