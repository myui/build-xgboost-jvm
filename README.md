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