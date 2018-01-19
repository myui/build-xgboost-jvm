if [ ! -f "$TRAVIS_BUILD_DIR/lib/libxgboost4j.so" ]; then
  echo "$TRAVIS_BUILD_DIR/lib/libxgboost4j.so does not found"
  echo "ls $TRAVIS_BUILD_DIR"
  ls $TRAVIS_BUILD_DIR
  echo "pwd=`pwd`"
  exit 1
fi

git clone --recursive --branch v${XGBOOST_VERSION} --depth 1 --single-branch https://github.com/dmlc/xgboost

cd xgboost/

cat make/config.mk | sed -e 's/USE_OPENMP = 1/USE_OPENMP = 0/' > config.mk
sed -i -e 's/LINK_LIBRARIES dmlccore/LINK_LIBRARIES dmlc/' CMakeLists.txt
sed -i -e 's/find_package(OpenMP)/find_package(Threads REQUIRED)/' CMakeLists.txt
sed -i -e 's/${CMAKE_CXX_FLAGS} -funroll-loops/${CMAKE_CXX_FLAGS} -funroll-loops -pthread' CMakeLists.txt

cd dmlc-core/
# https://github.com/dmlc/dmlc-core/commit/2777ad99d823848cbce6354688b397d519f7b810
git checkout ${DMLC_CORE_COMMIT_HASH}
sed -i -e 's/dmlccore_option(USE_OPENMP "Build with OpenMP" ON)/dmlccore_option(USE_OPENMP "Build with OpenMP" OFF)/' CMakeLists.txt

cd ../jvm-packages
sed -i -e 's/"USE_OPENMP": "ON"/"USE_OPENMP": "OFF"/' create_jni.py

export USE_OPENMP=0
./create_jni.py
otool -L xgboost4j/src/main/resources/lib/libxgboost4j.dylib

mvn -pl :xgboost4j package

cp xgboost4j/target/xgboost4j-$XGBOOST_VERSION.jar $TRAVIS_BUILD_DIR/xgboost4j-$XGBOOST_VERSION-$TRAVIS_OS_NAME.jar

mvn deploy:deploy-file \
  -s $TRAVIS_BUILD_DIR/settings.xml \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
  -DrepositoryId=sonatype-nexus-staging \
  -Dfile=$TRAVIS_BUILD_DIR/xgboost4j-$XGBOOST_VERSION-$TRAVIS_OS_NAME.jar \
  -DgroupId=io.github.myui \
  -DartifactId=xgboost4j \
  -Dversion=$XGBOOST_VERSION-$RC_NUMBER-$TRAVIS_OS_NAME \
  -Dpackaging=jar \
  -DgeneratePom=true

mv xgboost4j/target/xgboost4j-$XGBOOST_VERSION.jar $TRAVIS_BUILD_DIR/

cd $TRAVIS_BUILD_DIR
jar uf xgboost4j-$XGBOOST_VERSION.jar lib/libxgboost4j.so
echo 'jar tf xgboost4j-$XGBOOST_VERSION.jar | grep libxgboost4j'
jar tf xgboost4j-$XGBOOST_VERSION.jar | grep libxgboost4j

mvn deploy:deploy-file \
  -s $TRAVIS_BUILD_DIR/settings.xml \
  -Durl=https://oss.sonatype.org/service/local/staging/deploy/maven2/ \
  -DrepositoryId=sonatype-nexus-staging \
  -Dfile=$TRAVIS_BUILD_DIR/xgboost4j-$XGBOOST_VERSION.jar \
  -DgroupId=io.github.myui \
  -DartifactId=xgboost4j \
  -Dversion=$XGBOOST_VERSION-$RC_NUMBER \
  -Dpackaging=jar \
  -DgeneratePom=true
