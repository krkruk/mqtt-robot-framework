# Stage 1: Build the application
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG VITE_MQTT_BROKER_URL
ENV VITE_MQTT_BROKER_URL=$VITE_MQTT_BROKER_URL
RUN npm run build
COPY static ./build/static

# Stage 2: Serve the application
FROM node:18-alpine
WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package.json ./package.json
RUN npm install -g sirv-cli
WORKDIR /app/build
EXPOSE 8080
CMD ["sirv", ".", "--port", "8080", "--host", "--single"]
