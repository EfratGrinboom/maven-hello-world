# ============================================================
# Stage 1 - Build
# ============================================================
FROM maven:3.9.5-eclipse-temurin-11 AS build

WORKDIR /app

# Point to the pom.xml inside the myapp directory
COPY myapp/pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code from myapp/src and build
COPY myapp/src ./src
RUN mvn clean package -DskipTests

# ============================================================
# Stage 2 - Runtime
# ============================================================
FROM eclipse-temurin:11-jre-jammy

WORKDIR /app

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create a dedicated non-root user
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

# The JAR is built inside /app/target/ within the build container
COPY --from=build --chown=appuser:appgroup /app/target/*.jar app.jar

HEALTHCHECK --interval=30s --timeout=3s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1

USER appuser
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
