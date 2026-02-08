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

# Create a dedicated non-root user
RUN addgroup --system appgroup && adduser --system appuser --ingroup appgroup

# The JAR is built inside /app/target/ within the build container
COPY --from=build --chown=appuser:appgroup /app/target/*.jar app.jar

USER appuser
EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]