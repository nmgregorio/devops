#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}
VERSION=$(cat VERSION)

echo "Deploying to ${ENVIRONMENT} environment"
echo "Version: ${VERSION}"

# Check if overlay exists
if [[ ! -d "k8s-manifests/overlays/${ENVIRONMENT}" ]]; then
    echo "Environment ${ENVIRONMENT} not found. Available environments:"
    ls k8s-manifests/overlays/ 2>/dev/null || echo "No environments configured yet"
    exit 1
fi

# Apply kustomization
kubectl apply -k k8s-manifests/overlays/${ENVIRONMENT}

# Wait for deployment
kubectl rollout status deployment/learning-hub-deployment

echo "Deployment completed successfully!"
echo "Access your app at:"
kubectl get service learning-hub-service
