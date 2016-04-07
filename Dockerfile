FROM     centos:centos6

MAINTAINER Ashok Varadhan <ashok@smartek21.com>

RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN yum -y update
RUN yum -y install epel-release make monit vim-enhanced telnet wget tar gcc gcc-c++ sysstat && yum clean all

ENV NODE_VERSION v0.10.33

# Install Node.js and npm
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz && \
  tar xvzf node-${NODE_VERSION}.tar.gz && \
  rm -f node-${NODE_VERSION}.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  ln -s /usr/local/bin/node /usr/bin/node

# Install grunt
RUN npm install -g grunt-init grunt-cli grunt-shell

# Configure private module template 
COPY nodemodule /root/.grunt-init/nodemodule/

ENV HOME /root
ENV NODE_PATH /web/paccar:/web/paccar/node_modules
ENV NODE_ENV localhost

WORKDIR /web/paccar

EXPOSE 3000

CMD /sbin/init