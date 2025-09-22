#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get version from git or use default
if git rev-parse --git-dir > /dev/null 2>&1; then
    VERSION=$(git rev-parse --short HEAD)
else
    VERSION="latest"
fi

IMAGE_NAME="learning-hub"
FULL_IMAGE_NAME="${IMAGE_NAME}:${VERSION}"

echo -e "${YELLOW}Building Docker image: ${FULL_IMAGE_NAME}${NC}"

# Build the image
if docker build -t ${FULL_IMAGE_NAME} .; then
    echo -e "${GREEN}✓ Build successful!${NC}"
else
    echo -e "${RED}✗ Build failed!${NC}"
    exit 1
fi

# Tag as latest if this is main branch or no git
if [[ $(git branch --show-current 2>/dev/null) == "main" ]] || [[ ! -d .git ]]; then
    docker tag ${FULL_IMAGE_NAME} ${IMAGE_NAME}:latest
    echo -e "${GREEN}✓ Tagged as latest${NC}"
fi

# Show image info
echo -e "${YELLOW}Image built:${NC}"
docker images ${IMAGE_NAME}

echo -e "${GREEN}✓ Build completed successfully!${NC}"
echo -e "${YELLOW}To run locally: docker run -p 8080:80 ${FULL_IMAGE_NAME}${NC}"
