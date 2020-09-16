#ARG version=latest
FROM jenkins/inbound-agent:latest


ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

ARG user=jenkins



ENV ibmInstaller=agent.tar.gz
WORKDIR /tmp/imm/

USER root
ADD ${ibmInstaller} /tmp/imm
#ENV http_proxy http://il8p0008:8080
#ENV https_proxy https://il8p0008:8080
RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386
RUN cd agent && uname -a && ./installc -log /opt/im_install.log -acceptLicense && rm -rf /tmp/imm/

#RUN ['/tmp/client/installc','-log log.txt','-acceptLicense']

USER ${user}

ENTRYPOINT ["jenkins-agent"]
