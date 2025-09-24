#!/bin/bash
set -e

VERSION=$(cat VERSION)
IMAGE_NAME="learning-hub:${VERSION}"

echo "Building Docker image: ${IMAGE_NAME}"
docker build -t ${IMAGE_NAME} .

echo "Tagging as latest"
docker tag ${IMAGE_NAME} learning-hub:latest

echo "Build completed successfully!"
