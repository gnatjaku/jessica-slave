ARG version=4.3-8-alpine
FROM jenkins/agent:$version

ARG version
LABEL Description="This is a base image, which allows connecting Jenkins agents via JNLP protocols" Vendor="Jenkins project" Version="$version"

ARG user=jenkins

USER root
COPY agent.zip /tmp
RUN mkdir /tmp/client &&\
    mv /tmp/agent.zip /tmp/client/agent.zip &&\ 
    cd /tmp/client &&\
    unzip agent.zip &&\
    chmod 777 installc &&\
    ls -l install* &&\
    stat ./installc &&\ 
    #./installc -log log.txt -acceptLicense &&\
    ls -l install*
    #chmod +x /usr/local/bin/jenkins-agent &&\
    #ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave

RUN ['/tmp/client/installc','-log log.txt','-acceptLicense']

USER ${user}

ENTRYPOINT ["jenkins-agent"]