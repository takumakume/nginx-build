FROM centos:7.2.1511

RUN yum makecache fast
RUN yum install -y \
  rpmdevtools \
  bison \
  gcc \
  make \
  git \
  wget \
  openssl \
  openssl-devel \
  epel-release \
  httpd-devel

ADD . /root/rpmbuild
WORKDIR /root/rpmbuild

#RUN cp -pf /root/rpmbuild/roles/hoge/nginx.spec.patch /root/rpmbuild/SPECS/
