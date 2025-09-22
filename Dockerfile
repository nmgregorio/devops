FROM nginx:alpine

# Copy HTML to nginx web directory  
COPY src/index.html /usr/share/nginx/html/

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
