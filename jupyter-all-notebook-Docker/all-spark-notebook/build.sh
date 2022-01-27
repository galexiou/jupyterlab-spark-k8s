#!/bin/bash

set -e

REPONAME=galexiou
TAG=all-spark-notebook

docker build -t $TAG .

# Tag and push to the public docker repository.
docker tag $TAG $REPONAME/$TAG
docker push $REPONAME/$TAG
