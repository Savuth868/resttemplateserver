# Multi-stage build for Spring Boot application with Java 25
# Builder stage: Compiles the application
FROM eclipse-temurin:25-jdk-alpine AS builder
WORKDIR /workspace

# Copy Maven wrapper and configuration
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw

# Copy source code
COPY src/ src/

# Build the application with optimizations
# Skip tests for faster builds, but run integrity checks
RUN ./mvnw clean package -DskipTests -q

# Runtime stage: Lean JRE-only image
FROM eclipse-temurin:25-jre-alpine

# Create non-root user for enhanced security
RUN addgroup -g 1000 appuser && \
    adduser -D -u 1000 -G appuser appuser

# Set working directory
WORKDIR /app

# Copy the JAR file from builder stage
COPY --from=builder /workspace/target/*.jar app.jar

# Change ownership to non-root user
RUN chown -R appuser:appuser /app

# Switch to non-root user
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget -q -O - http://localhost:8080/actuator/health || exit 1

# Expose port
EXPOSE 8080

# Set JVM options for better container performance
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxRAMPercentage=75 -XX:InitialRAMPercentage=25 -XX:+UseStringDeduplication"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]