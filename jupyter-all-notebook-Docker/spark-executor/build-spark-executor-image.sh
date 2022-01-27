#!/bin/bash

APACHE_SPARK_VERSION="3.2.0"
HADOOP_VERSION="3.3.1"
REPONAME="galexiou"
TAG="spark3.2-h3.3.1"
ICEBERG_VERSION="0.12.1"

#wget -q "https://archive.apache.org/dist/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-without-hadoop.tgz" && \
#tar xzf "spark-${APACHE_SPARK_VERSION}-bin-without-hadoop.tgz"

#wget -q "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark3-runtime/${ICEBERG_VERSION}/iceberg-spark3-runtime-${ICEBERG_VERSION}.jar" && \
#mv  "iceberg-spark3-runtime-${ICEBERG_VERSION}.jar" spark-${APACHE_SPARK_VERSION}-bin-without-hadoop/jars/

cp Dockerfile "spark-${APACHE_SPARK_VERSION}-bin-without-hadoop/"

cd "spark-${APACHE_SPARK_VERSION}-bin-without-hadoop/"

docker build -t $TAG  .

# Tag and push to the public docker repository.
docker tag $TAG $REPONAME/$TAG
docker push $REPONAME/$TAG

#sudo chmod +x spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin/docker-image-tool.sh

#/bin/bash spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin/docker-image-tool.sh -r ${REPO_NAME} -t ${TAG_NAME} build

#/bin/bash spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/bin/docker-image-tool.sh -r ${REPO_NAME} -t ${TAG_NAME} push

# rm "spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
