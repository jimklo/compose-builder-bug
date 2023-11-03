#!/bin/bash

# I need to do this because we have Zero Trust certificates.
# I have locally built a base container that is the same as the docker.io base
# but with updated certificate authorities.
BUILD_ARGS="--build-arg 'REGISTRY=containers-internal.sri.com'"

echo ""
echo "********** DOCKER VERSION **************"
docker version

echo ""
echo "****************************************************************************************"
echo "********** Show which builders are available and set as default"
docker buildx ls

echo ""
echo "****************************************************************************************"
echo "********** Build base container using docker BuildKit"
docker buildx build ${BUILD_ARGS} --tag my-base:latest --no-cache --load .

echo ""
echo "****************************************************************************************"
echo "********** Show that base image built"
docker images my-base

echo ""
echo "****************************************************************************************"
echo "********** Try building the derivative image using docker compose"
docker compose build

echo ""
echo "****************************************************************************************"
echo "********** Now build the derivative image using docker BuildKit"
docker buildx build -f Dockerfile.derivative --tag my-derived:latest --load .

echo "****************************************************************************************"
echo "********** Show that derived built that this built"
docker images my-derived


echo ""
echo "****************************************************************************************"
echo "********** Try running the built image using compose"
docker compose run derived


