git clone --recursive --depth 1 https://github.com/dmlc/xgboost

cd xgboost/
git checkout -b v${XGBOOST_VERSION}

cat make/config.mk | sed -e 's/USE_OPENMP = 1/USE_OPENMP = 0/' > config.mk
sed -i -e 's/find_package(OpenMP)/find_package(Threads REQUIRED)/' CMakeLists.txt
sed -i -e 's/set_default_configuration_release()/set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -funroll-loops -pthread -fvisibility=hidden")/' CMakeLists.txt
sed -i -e 's/USE_OPENMP "Build with OpenMP support." ON/USE_OPENMP "Build with OpenMP support." OFF/' CMakeLists.txt

cd dmlc-core/
sed -i -e 's/dmlccore_option(USE_OPENMP "Build with OpenMP" ON)/dmlccore_option(USE_OPENMP "Build with OpenMP" OFF)/' CMakeLists.txt

cd ../jvm-packages
sed -i -e 's/"USE_OPENMP": "ON"/"USE_OPENMP": "OFF"/' create_jni.py

# brew install cmake

export USE_OPENMP=0
./create_jni.py
otool -L xgboost4j/src/main/resources/lib/libxgboost4j.dylib

rm xgboost4j/src/main/scala/ml/dmlc/xgboost4j/LabeledPoint.scala
curl -O https://raw.githubusercontent.com/myui/build-xgboost-jvm/master/src/LabeledPoint.java
mv LabeledPoint.java xgboost4j/src/main/java/ml/dmlc/xgboost4j/

# export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
mvn -pl :xgboost4j package

mv xgboost4j/target/xgboost4j-$XGBOOST_VERSION.jar $TRAVIS_BUILD_DIR/xgboost4j-$XGBOOST_VERSION-$TRAVIS_OS_NAME.jar
