# Stage 1: Build the native executable
FROM ghcr.io/graalvm/native-image:latest AS builder

WORKDIR /app

# Install jbang
RUN curl -Ls https://sh.jbang.dev | bash -s - app setup

# Copy the project files
COPY build.gradle settings.gradle ./
COPY src ./src

# Build the native executable
RUN ~/.jbang/bin/jbang --java 21 --fresh gradle@info.picocli:jbang-catalog nativeCompile


# Stage 2: Create the final, minimal image
FROM debian:12-slim

WORKDIR /app

# Copy the native executable from the builder stage
COPY --from=builder /app/build/native/nativeCompile/uart-mqtt-gateway .

# Expose the application port defined in the configuration
EXPOSE 8088

# Set the entrypoint to run the application
# Note: To access serial ports, the container must be run with appropriate privileges,
# for example: docker run -d --privileged -v /dev:/dev uart-mqtt-gateway
ENTRYPOINT ["./uart-mqtt-gateway"]
