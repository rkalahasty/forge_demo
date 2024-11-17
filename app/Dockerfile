# Use the official Julia image as the base image
FROM julia:1.9.3

# Set the working directory inside the container
WORKDIR /app

# Copy the source code into the container
COPY src/ ./src/

# Install required Julia packages
RUN julia -e 'using Pkg; Pkg.add(["HTTP", "LibPQ", "SQLite", "Sockets", "Printf"])'

# Precompile the Julia packages for faster startup
RUN julia -e 'using HTTP, LibPQ, SQLite, Sockets, Printf'

# Expose the port the app will run on
EXPOSE 8080

# Set the environment variables for the RDS connection (can also be passed during deployment)
ENV DB_HOST=<your-rds-host>
ENV DB_NAME=<your-db-name>
ENV DB_USER=<your-db-user>
ENV DB_PASSWORD=<your-db-password>
ENV DB_PORT=5432

# Command to run the application
CMD ["julia", "src/main.jl"]
