# Use an official Java runtime as a base image
FROM openjdk:11-jre-slim

# Install required tools: curl and unzip (if needed)
RUN apt-get update && \
    apt-get install -y curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /minecraft

# Copy the update script into the image
COPY update-plugins.sh /minecraft/update-plugins.sh
RUN chmod +x /minecraft/update-plugins.sh

# Run the update script when the container starts
CMD ["/minecraft/update-plugins.sh"]
