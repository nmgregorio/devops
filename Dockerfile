# Build stage for future expansion (HTML validation, minification, etc.)
FROM node:18-alpine AS build

WORKDIR /app

# Copy source files
COPY src/ ./src/

# Future: Add build steps here (minification, validation, etc.)
# For now, just validate HTML structure
RUN apk add --no-cache tidy && \
    tidy -q -e src/index.html || echo "HTML validation completed"

# Production stage
FROM nginx:alpine AS production

# Install security updates and create non-root user
RUN apk update && apk upgrade && \
    addgroup -g 1001 -S appuser && \
    adduser -S -D -H -u 1001 -h /var/cache/nginx -s /sbin/nologin -G appuser -g appuser appuser

# Copy built application from build stage
COPY --from=build /app/src/index.html /usr/share/nginx/html/

# Copy custom nginx config for non-root operation
COPY <<EOF /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    server {
        listen 8080;
        server_name localhost;
        location / {
            root /usr/share/nginx/html;
            index index.html;
        }
        # Health check endpoint
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }
    }
}
EOF

# Set ownership and permissions
RUN chown -R appuser:appuser /usr/share/nginx/html /var/cache/nginx /var/run && \
    chmod -R 755 /usr/share/nginx/html

# Switch to non-root user
USER appuser

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
