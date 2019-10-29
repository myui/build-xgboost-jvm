# build-xgboost-jvm
[![Build Status](https://travis-ci.org/myui/build-xgboost-jvm.svg?branch=master)](https://travis-ci.org/myui/build-xgboost-jvm) 
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/io.github.myui/xgboost4j/badge.svg)](https://search.maven.org/#search%7Cga%7C1%7Cg%3A%22io.github.myui%22%20a%3Axgboost4j) 
[![License](http://img.shields.io/:license-Apache_v2-blue.svg)](https://github.com/myui/build-xgboost-jvm/blob/master/LICENSE)

Repository to build xgboost4j for Linux/MacOSX using TravisCI. 

When pushing a tag to git, TravisCI automatically creates a release.

# Using xgboost4j

This project publishes xgboost4j to Maven central that contains portable binaries for MacOSX and Linux. 
DMLC's [xgboost](https://github.com/dmlc/xgboost/) is a great library but, as seen in [this issue](https://github.com/dmlc/xgboost/issues/1807), it is not published to maven central yet.

```
<dependency>
    <groupId>io.github.myui</groupId>
    <artifactId>xgboost4j</artifactId>
    <version>0.9-rc1</version>
</dependency>
```

# Portability

# Update shared library in jar
```sh
jar uf xgboost4j-0.9-rc1.jar lib/libxgboost4j.dylib
jar tf xgboost4j-0.9-rc1.jar | grep libxgboost4j
```

Compilied shared libraries (i.e., libxgboost4j.dylib|so) are a portable one without dependencies to openmp and libc++ (for linux) as follows:
Minimum requirement for GLIBC is [2.15](https://abi-laboratory.pro/tracker/timeline/glibc/).

```sh
xgboost4j/src/main/resources/lib/libxgboost4j.dylib:
    @rpath/libxgboost4j.dylib (compatibility version 0.0.0, current version 0.0.0)
    @rpath/libjvm.dylib (compatibility version 1.0.0, current version 1.0.0)
    /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 120.1.0)
    /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1226.10.1)

xgboost4j/src/main/resources/lib/libxgboost4j.so:
	linux-vdso.so.1 =>  (0x00007ffe475bc000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f1ca5f8d000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f1ca5c91000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f1ca5a74000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f1ca56b3000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f1ca681d000)

$ strings xgboost4j/src/main/resources/lib/libxgboost4j.so | grep ^GLIBC | sort
GLIBC_2.14
GLIBC_2.2.5
GLIBC_2.3
GLIBC_2.3.2
GLIBC_2.3.4
GLIBC_2.4
 ```
 
You can find requirements in your environment by `strings /lib/x86_64-linux-gnu/libc.so.6 | grep ^GLIBC | sort`.

# Release to Maven central

## Release to Staging

```sh
export NEXUS_PASSWD=xxxx
export XGBOOST_VERSION=0.7
export RC_NUMBER=2

mvn gpg:sign-and-deploy-file \
  -s ./settings.xml \
  -DpomFile=./xgboost4j.pom \
  -DrepositoryId=sonatype-nexus-staging \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
  -Dfile=dist/xgboost4j-${XGBOOST_VERSION}-rc${RC_NUMBER}.jar \
  -Djavadoc=dist/xgboost4j-${XGBOOST_VERSION}-rc${RC_NUMBER}-javadoc.jar \
  -Dsources=dist/xgboost4j-${XGBOOST_VERSION}-rc${RC_NUMBER}-sources.jar
```

## Release from Staging

1. Log in to [oss.sonatype.com](https://oss.sonatype.org/)
2. Click on “Staging Repositories” under Build Promotion
3. Verify the content of the repository (in the bottom pane), check it, click Close, confirm
4. Check the repo again, click “Release”
5. You shall now see your artifacts in the release repository created for you
6. In some hours, it should also appear in Maven Central
