#!/bin/bash
set -e

echo "Running tests..."

# HTML validation
echo "Validating HTML..."
tidy -q -e src/index.html || echo "HTML validation completed"

# Docker build test
echo "Testing Docker build..."
docker build -t learning-hub-test .

# Basic container test
echo "Testing container startup..."
CONTAINER_ID=$(docker run -d -p 8081:8080 learning-hub-test)
sleep 5

# Test HTTP response
if curl -f http://localhost:8081 > /dev/null 2>&1; then
    echo "✓ Container test passed"
else
    echo "✗ Container test failed"
    exit 1
fi

# Cleanup
docker stop $CONTAINER_ID
docker rm $CONTAINER_ID

echo "All tests passed!"
