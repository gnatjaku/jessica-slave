#ARG version=latest
FROM jenkins/inbound-agent:latest


ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

ARG user=jenkins



ENV ibmInstaller=agent.tar.gz
ENV WAS_CLIENT_HOME=/opt/IBM/WebSphere/AppClient85
ENV WDR_HOME=/opt/WDR
WORKDIR /tmp/imm/

USER root
ADD ${ibmInstaller} /tmp/imm
ADD debs32.tar /tmp/imm
ADD WDR-master.zip /opt/
ADD wdr-envs.zip /opt/
RUN unzip /opt/WDR-master.zip -d /opt && rm /opt/WDR-master.zip && mv /opt/WDR-master /opt/WDR 
RUN dpkg --add-architecture i386
#RUN cp /tmp/imm/archives/* /var/cache/apt/archives/ && ls /var/cache/apt/archives/
#RUN apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 zlib1g:i386
RUN dpkg -i archives/libc6_2.28-10_i386.deb archives/gcc-8-base_8.3.0-6_i386.deb archives/libgcc1_1%3a8.3.0-6_i386.deb archives/libstdc++6_8.3.0-6_i386.deb archives/zlib1g_1%3a1.2.11.dfsg-1_i386.deb
RUN cd agent && uname -a && ./installc -log /opt/im_install.log -acceptLicense && rm -rf /tmp/imm/
RUN /opt/IBM/InstallationManager/eclipse/tools/imcl install \
    com.ibm.websphere.APPCLIENT.v85,javaee.thinclient.core.feature,javaruntime,developerkit,standalonethinclient.resourceadapter.runtime,embeddablecontainer \
    -repositories http://10.234.24.13/data/repos/soft/repoappclient \
    -installationDirectory /opt/IBM/WebSphere/AppClient85 \
    -acceptLicense \
    -properties user.wasjava=java8,user.appclient.serverHostname=localhost,user.appclient.serverPort=2809 \
    -preferences com.ibm.cic.common.core.preferences.preserveDownloadedArtifacts=false

RUN update-alternatives --install /bin/sh sh /bin/bash 100
RUN apt-get install -y git
RUN apt-get update
RUN apt-get install -y python-pip
RUN pip install requests
ADD jython21.class /opt/IBM/WebSphere/AppClient85/optionalLibraries/jython21.class
ADD jython27.tar.gz /opt/IBM/WebSphere/AppClient85/optionalLibraries/
ADD jython.tar.gz /opt/IBM/WebSphere/AppClient85/optionalLibraries/
RUN usermod -d /var/jenkins_home ${user} && chmod -R 777 /tmp 

USER ${user}
ENV HOME /var/jenkins_home

ENTRYPOINT ["jenkins-agent"]
