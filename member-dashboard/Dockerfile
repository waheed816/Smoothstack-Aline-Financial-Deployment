# FROM nginx:alpine

# RUN rm -f /usr/share/nginx/html/index.html
# RUN rm -f /usr/share/nginx/html/50x.html

# COPY dist/aline-member-dashboard/ /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

#jenkins experiment 45

# Stage 1 build
FROM node:14 as build

# Set the working directory
WORKDIR /app

# Copy application code
COPY . .

# Print all environment variables
RUN printenv

# Install dependencies and build application
RUN npm install
RUN npm run build

# Print all environment variables
RUN printenv

# Stage 2 build
FROM nginx:alpine

RUN rm -f /usr/share/nginx/html/index.html
RUN rm -f /usr/share/nginx/html/50x.html

COPY --from=build /app/dist/aline-member-dashboard /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
