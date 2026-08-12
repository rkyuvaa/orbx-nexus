# Stage 1: Build React static assets
FROM node:20-slim AS build
WORKDIR /app
ENV NODE_OPTIONS="--max-old-space-size=2048"
COPY package*.json ./
RUN npm ci
COPY . .
RUN npx vite build

# Stage 2: Serve using Nginx
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
