FROM centos:centos6

# EPEL/REMIインストール
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN yum -y update && \
    yum -y install ansible && \
    yum -y update gmp

RUN mkdir /tmp/ansible
ADD ./playbook.yml /tmp/ansible/
WORKDIR /tmp/ansible
RUN ansible-playbook playbook.yml

USER worker
ENV HOME /home/worker
WORKDIR /home/worker

RUN wget git.io/nodebrew &&\
    perl nodebrew setup && \
    echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" > /home/worker/.bashrc

RUN source /home/worker/.bashrc && \
    nodebrew install-binary v0.10.35 && \
    nodebrew use v0.10.35

#################################
# default behavior is to login by worker user
#################################
CMD ["su", "-", "worker"]
