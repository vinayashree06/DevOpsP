FROM node:18-alpine

WORKDIR /app

# Copy package files from frontend subdirectory
COPY frontend/package*.json ./

RUN npm install

# Copy the rest of the app
COPY frontend/ ./

RUN npm run build

# Serve build with nginx
FROM nginx:alpine
COPY --from=0 /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
