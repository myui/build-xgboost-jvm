#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM ubuntu:precise
MAINTAINER Makoto Yui <myui@apache.org>

ENV XGBOOST_VERSION=0.7
ENV RC_VERSION=3
ENV DMLC_CORE_COMMIT_HASH=2777ad99d823848cbce6354688b397d519f7b810

WORKDIR /work

COPY ./scripts/docker_build.sh .

RUN set -eux && \
    apt-get update && \
    apt-get install -y software-properties-common python-software-properties && \
	add-apt-repository -y ppa:george-edison55/cmake-3.x && \
	add-apt-repository -y ppa:george-edison55/precise-backports && \
	add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
	apt-get update && \
	apt-get install -y vim maven binutils git g++-4.9 openjdk-7-jdk make cmake libpthread-stubs0-dev && \
	export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64 && \
	update-alternatives --install `which java` java ${JAVA_HOME}/bin/java 1062 && \
	CC=`which gcc-4.9` CXX=`which g++-4.9` sh -x ./docker_build.sh && \
	rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /root/.m2/*

VOLUME ["/tmp", "/mnt/host/tmp"]

CMD ["bash"]