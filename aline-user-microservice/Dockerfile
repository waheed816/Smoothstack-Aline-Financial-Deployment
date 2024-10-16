# # Use the official OpenJDK base image
# FROM openjdk:11-jre-slim

# # Set the working directory in the container
# WORKDIR /app

# # Copy enviroment variables
# COPY user-microservice/src/main/resources/.env ./

# # Copy the application JAR file into the container
# COPY user-microservice/target/user-microservice-0.1.0.jar ./

# # Expose the port specified in the copied .env file
# EXPOSE ${APP_PORT}

# # Run the application
# CMD ["java", "-jar", "user-microservice-0.1.0.jar"]

#jenkins experiment 45

# ----------- RUN THIS IF CODE BASE CHANGES -----------#
# Use the official Maven image as a build stage
FROM maven:3.8.4-openjdk-17 AS build

# Create a working directory
WORKDIR /app

# Copy all files to the working directory
COPY . .

# Compile the code into a JAR file
RUN mvn clean package -DskipTests

# Use the official OpenJDK base image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy enviroment variables
COPY --from=build /app/user-microservice/src/main/resources/.env ./

# Copy the new application JAR file file into the container
COPY --from=build /app/user-microservice/target/user-microservice-0.1.0.jar ./

# Expose the port specified in the copied .env file
EXPOSE ${APP_PORT}

# Run the application
CMD ["java", "-jar", "user-microservice-0.1.0.jar"]
