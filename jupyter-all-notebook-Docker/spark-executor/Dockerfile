#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
ARG java_image_tag=11-jre-slim


FROM openjdk:${java_image_tag}

ARG spark_uid=185
ARG iceberg_version="0.12.1"
ARG hadoop_version="3.3.1"

ENV HADOOP_VERSION="${hadoop_version}"
# Before building the docker image, first build and make a Spark distribution following
# the instructions in http://spark.apache.org/docs/latest/building-spark.html.
# If this docker file is being used in the context of building your images from a Spark
# distribution, the docker build command should be invoked from the top level directory
# of the Spark distribution. E.g.:
# docker build -t spark:latest -f kubernetes/dockerfiles/spark/Dockerfile .

RUN set -ex && \
    sed -i 's/http:\/\/deb.\(.*\)/https:\/\/deb.\1/g' /etc/apt/sources.list && \
    apt-get update && \
    ln -s /lib /lib64 && \
    apt install -y bash tini libc6 libpam-modules krb5-user libnss3 procps wget && \
    mkdir -p /opt/spark && \
    mkdir -p /opt/spark/examples && \
    mkdir -p /opt/spark/work-dir && \
    touch /opt/spark/RELEASE && \
    rm /bin/sh && \
    ln -sv /bin/bash /bin/sh && \
    echo "auth required pam_wheel.so use_uid" >> /etc/pam.d/su && \
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    rm -rf /var/cache/apt/*

COPY jars /opt/spark/jars
COPY bin /opt/spark/bin
COPY sbin /opt/spark/sbin
COPY kubernetes/dockerfiles/spark/entrypoint.sh /opt/
COPY kubernetes/dockerfiles/spark/decom.sh /opt/
COPY examples /opt/spark/examples
COPY kubernetes/tests /opt/spark/tests
COPY data /opt/spark/data

ENV SPARK_HOME /opt/spark

# Download and extract the Hadoop binary package.
RUN mkdir /opt/hadoop
RUN wget -q "https://archive.apache.org/dist/hadoop/core/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
	# | tar xvz -C /opt/  \
  && tar xzf "hadoop-$HADOOP_VERSION.tar.gz" -C /opt/ \
	&& mv -v /opt/hadoop-$HADOOP_VERSION/* /opt/hadoop \
	&& rm -r /opt/hadoop/share/doc \
  && rm hadoop-$HADOOP_VERSION.tar.gz

  # Add S3a jars to the classpath using this hack.
  RUN ln -s /opt/hadoop/share/hadoop/tools/lib/hadoop-aws* /opt/hadoop/share/hadoop/common/lib/ && \
      ln -s /opt/hadoop/share/hadoop/tools/lib/aws-java-sdk* /opt/hadoop/share/hadoop/common/lib/


  # Add Azure jars to the classpath using this hack.
  RUN ln -s /opt/hadoop/share/hadoop/tools/lib/azure-data* /opt/hadoop/share/hadoop/common/lib/ && \
      ln -s /opt/hadoop/share/hadoop/tools/lib/hadoop-azure* /opt/hadoop/share/hadoop/common/lib/ && \
  		ln -s /opt/hadoop/share/hadoop/tools/lib/azure-storage* /opt/hadoop/share/hadoop/common/lib/ && \
  		ln -s /opt/hadoop/share/hadoop/tools/lib/azure-keyvault* /opt/hadoop/share/hadoop/common/lib/

ENV HADOOP_HOME "/opt/hadoop"
ENV PATH "$SPARK_HOME/bin:$HADOOP_HOME/bin:$PATH"

ENV SPARK_DIST_CLASSPATH "/opt/hadoop/etc/hadoop:/opt/hadoop/share/hadoop/common/lib/*:/opt/hadoop/share/hadoop/common/*:/opt/hadoop/share/hadoop/hdfs:/opt/hadoop/share/hadoop/hdfs/lib/*:/opt/hadoop/share/hadoop/hdfs/*:/opt/hadoop/share/hadoop/mapreduce/*:/opt/hadoop/share/hadoop/yarn:/opt/hadoop/share/hadoop/yarn/lib/*:/opt/hadoop/share/hadoop/yarn/*"

WORKDIR /opt/spark/work-dir
RUN chmod g+w /opt/spark/work-dir
RUN chmod a+x /opt/decom.sh
# Specify the User that the actual main process will run as
USER ${spark_uid}

ENTRYPOINT [ "/opt/entrypoint.sh" ]
