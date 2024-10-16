# # Use the official OpenJDK base image
# FROM openjdk:11-jre-slim

# # Set the working directory in the container
# WORKDIR /app

# # Copy the application JAR file into the container
# COPY target/aline-gateway-0.0.1-SNAPSHOT.jar ./

# # Copy environmental variables
# # COPY src/main/resources/.env ./

# # COPY --from=build src/main/resources/.env ./

# # Expose the port specified in the copied .env file
# # EXPOSE ${APP_PORT}

# EXPOSE 8080

# # Run the application
# CMD ["java", "-jar", "aline-gateway-0.0.1-SNAPSHOT.jar"]

#jenkins experiment 45

# ----------- RUN THIS IF CODE BASE CHANGES -----------#
# Use the official Maven image as a build stage 1
FROM maven:3.8.4-openjdk-17 AS build

# Create a working directory
WORKDIR /app

# Copy all files to the working directory
COPY . .

# Compile the code into a JAR file
RUN mvn clean package -DskipTests

# Use the official OpenJDK base image for build stage 2
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the new application JAR file file into the container
COPY --from=build /app/target/aline-gateway-0.0.1-SNAPSHOT.jar ./

# Copy environmental variables
COPY --from=build /app/src/main/resources/.env ./

# ENV APP_PORT=8080
# ENV APP_SERVICE_HOST=host.docker.internal
# ENV PORTAL_LANDING=http://localhost:3007
# ENV PORTAL_DASHBOARD=http://localhost:4200
# ENV PORTAL_ADMIN=http://localhost:3000

# Expose the port specified in the copied .env file
EXPOSE ${APP_PORT}

# Run the application
CMD ["java", "-jar", "aline-gateway-0.0.1-SNAPSHOT.jar"]
