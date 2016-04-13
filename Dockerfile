FROM centos:7

MAINTAINER Mike Shuey <shuey@fmepnet.org>


ENV CEPH_VERSION infernalis
ENV GOPATH=/root/work

ADD ceph.repo /etc/yum.repos.d/ceph.repo
RUN echo "${CEPH_VERSION}" > /etc/yum/vars/cephrelease && \
    echo "el7" > /etc/yum/vars/distro && \
    rpm --import 'https://download.ceph.com/keys/release.asc' && \
    yum update -y &&\
    yum install -y epel-release && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && \
    yum install -y git make golang rpm-build && \
    yum install -y ceph librados2-devel librbd1-devel && \
    yum clean all && \
    mkdir /root/work


ENV SRC_ROOT /root/work/src/github.com/yp-engineering/rbd-docker-plugin

# Setup our directory and give convenient path via ln.
RUN mkdir -p ${SRC_ROOT}
RUN ln -s ${SRC_ROOT} /rbd-docker-plugin
WORKDIR ${SRC_ROOT}

# Used to only go get if sources change.
ADD *.go ${SRC_ROOT}/
RUN go get -t .

# Add the rest of the files.
ADD . ${SRC_ROOT}

CMD ["bash"]
