git clone --recursive --branch v${XGBOOST_VERSION} --depth 1 https://github.com/dmlc/xgboost

cd xgboost/

cat make/config.mk | sed -e 's/USE_OPENMP = 1/USE_OPENMP = 0/' > config.mk
sed -i -e 's/find_package(OpenMP)/find_package(Threads REQUIRED)/' CMakeLists.txt
sed -i -e 's/set_default_configuration_release()/set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -funroll-loops -pthread -static-libgcc -static-libstdc++ -fvisibility=hidden")/' CMakeLists.txt
sed -i -e 's/USE_OPENMP "Build with OpenMP support." ON/USE_OPENMP "Build with OpenMP support." OFF/' CMakeLists.txt

cd dmlc-core/
sed -i -e 's/dmlccore_option(USE_OPENMP "Build with OpenMP" ON)/dmlccore_option(USE_OPENMP "Build with OpenMP" OFF)/' CMakeLists.txt

cd ../jvm-packages
sed -i -e 's/"USE_OPENMP": "ON"/"USE_OPENMP": "OFF"/' create_jni.py

export USE_OPENMP=0
./create_jni.py
ldd xgboost4j/src/main/resources/lib/libxgboost4j.so
strings xgboost4j/src/main/resources/lib/libxgboost4j.so | grep ^GLIBC | sort

find . -name pom.xml | xargs sed -i -e "s|<version>${XGBOOST_VERSION}</version>|<version>${XGBOOST_VERSION}-rc${RC_NUMBER}</version>|"

rm xgboost4j/src/main/scala/ml/dmlc/xgboost4j/LabeledPoint.scala
wget --no-check-certificate https://raw.githubusercontent.com/myui/build-xgboost-jvm/master/src/LabeledPoint.java
mv LabeledPoint.java xgboost4j/src/main/java/ml/dmlc/xgboost4j/

mvn -pl :xgboost4j package javadoc:jar source:jar

mv xgboost4j/target/xgboost4j-$XGBOOST_VERSION.jar $TRAVIS_BUILD_DIR/xgboost4j-$XGBOOST_VERSION-$TRAVIS_OS_NAME-$TRAVIS_DIST.jar
mv xgboost4j/target/xgboost4j-$XGBOOST_VERSION-sources.jar $TRAVIS_BUILD_DIR/
mv xgboost4j/target/xgboost4j-$XGBOOST_VERSION-javadoc.jar $TRAVIS_BUILD_DIR/