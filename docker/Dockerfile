FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install curl -y

# MAKE
RUN apt-get install make -y

# CFSSL
RUN curl -L -o /opt/cfssl https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
RUN curl -L -o /opt/cfssljson https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64

# JQ
RUN curl -L -o /opt/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64

# KUBECTL
RUN curl -L -o /opt/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.2.4/bin/linux/amd64/kubectl

# TERRAFORM
RUN curl -L -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.6.16/terraform_0.6.16_linux_amd64.zip
RUN apt-get install unzip -y
RUN unzip /tmp/terraform.zip -d /opt

# AWS
RUN curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN apt-get install python -y
RUN python /tmp/get-pip.py
RUN pip install awscli

RUN chmod 755 /opt/*

ENV PATH $PATH:/opt

RUN mkdir /cluster
WORKDIR /cluster

RUN apt-get install ca-certificates -y
RUN apt-get install git -y
RUN apt-get install openssl -y

CMD make all
