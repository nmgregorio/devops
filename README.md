# Full-Stack Learning App

A sample application for learning Kubernetes and DevOps practices.

## Quick Start
```bash
# Build the application
./scripts/build.sh

# Deploy to Kubernetes
kubectl apply -f k8s-manifests/

# Access the application
kubectl get service learning-hub-service

test
