FROM eclipse-temurin:17-jdk-jammy-20250603 AS builder
WORKDIR /workspace

COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw

COPY src/ src/
RUN ./mvnw clean package -DskipTests

FROM eclipse-temurin:17-jre-jammy-20250603
WORKDIR /app

COPY --from=builder /workspace/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]