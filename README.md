This project publishes xgboost4j to Maven central that contains portable binaries for MacOSX and Linux. 
DMLC's [xgboost](https://github.com/dmlc/xgboost/) is a great library but, as seen in [this issue](https://github.com/dmlc/xgboost/issues/1807), it is not published to maven central yet.

# Using xgboost4j

```
<dependency>
    <groupId>io.github.myui</groupId>
    <artifactId>xgboost4j</artifactId>
    <version>0.7-rc1</version>
</dependency>
```

# build-xgboost-jvm
[![Build Status](https://travis-ci.org/myui/build-xgboost-jvm.svg?branch=master)](https://travis-ci.org/myui/build-xgboost-jvm)

Repository to build xgboost4j for Linux/MacOSX using TravisCI

When pushing a tag to git, TravisCI automatically creates a release.

Compilied shared libraries (i.e., libxgboost4j.dylib|so) are a portable one without dependencies to openmp and libc++ (for linux) as follows:

```sh
xgboost4j/src/main/resources/lib/libxgboost4j.dylib:
    @rpath/libxgboost4j.dylib (compatibility version 0.0.0, current version 0.0.0)
    @rpath/libjvm.dylib (compatibility version 1.0.0, current version 1.0.0)
    /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 120.1.0)
    /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1226.10.1)

xgboost4j/src/main/resources/lib/libxgboost4j.so:
    linux-vdso.so.1 =>  (0x00007ffc54239000)
    libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f6256e9f000)
    libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f6256c81000)
    libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f62568b8000)
    /lib64/ld-linux-x86-64.so.2 (0x00007f6257741000)
 ```

# Release to Maven central

## Release to Staging

```sh
export XGBOOST_VERSION=0.7-rc1

mvn gpg:sign-and-deploy-file \
  -s ./settings.xml \
  -DpomFile=./xgboost4j.pom \
  -DrepositoryId=sonatype-nexus-staging \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
  -Dfile=dist/${XGBOOST_VERSION}/xgboost4j-${XGBOOST_VERSION}.jar \
  -Djavadoc=dist/${XGBOOST_VERSION}/xgboost4j-${XGBOOST_VERSION}-javadoc.jar \
  -Dsources=dist/${XGBOOST_VERSION}/xgboost4j-${XGBOOST_VERSION}-sources.jar
```

## Release from Staging

1. Log in to [oss.sonatype.com](https://oss.sonatype.org/)
2. Click on “Staging Repositories” under Build Promotion
3. Verify the content of the repository (in the bottom pane), check it, click Close, confirm
4. Check the repo again, click “Release”
5. You shall now see your artifacts in the release repository created for you
6. In some hours, it should also appear in Maven Central
