git clone --recursive --branch v${XGBOOST_VERSION} --depth 1 https://github.com/dmlc/xgboost

cd xgboost/

cat make/config.mk | sed -e 's/USE_OPENMP = 1/USE_OPENMP = 0/' > config.mk
sed -i -e 's/LINK_LIBRARIES dmlccore/LINK_LIBRARIES dmlc/' CMakeLists.txt
sed -i -e 's/find_package(OpenMP)/find_package(Threads REQUIRED)/' CMakeLists.txt
sed -i -e 's/${CMAKE_CXX_FLAGS} -funroll-loops/${CMAKE_CXX_FLAGS} -funroll-loops -pthread -static-libgcc -static-libstdc++ -fvisibility=hidden/' CMakeLists.txt

cd dmlc-core/
# https://github.com/dmlc/dmlc-core/commit/2777ad99d823848cbce6354688b397d519f7b810
git checkout ${DMLC_CORE_COMMIT_HASH}
sed -i -e 's/dmlccore_option(USE_OPENMP "Build with OpenMP" ON)/dmlccore_option(USE_OPENMP "Build with OpenMP" OFF)/' CMakeLists.txt

cd ../jvm-packages
sed -i -e 's/"USE_OPENMP": "ON"/"USE_OPENMP": "OFF"/' create_jni.py

export USE_OPENMP=0
./create_jni.py
ldd xgboost4j/src/main/resources/lib/libxgboost4j.so
strings xgboost4j/src/main/resources/lib/libxgboost4j.so | grep ^GLIBC

find . -name pom.xml | xargs sed -i -e "s|<version>0.8-SNAPSHOT</version>|<version>${XGBOOST_VERSION}-rc${RC_NUMBER}</version>|"

mvn -pl :xgboost4j package javadoc:jar source:jar

