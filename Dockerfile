FROM debian:bullseye

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget unzip

ENV PORT=1212
ENV UID=568
ENV GID=568

# Environment variable for the game server download URL
ARG GAME_SERVER_URL

# Create a new group and user
RUN addgroup --gid $GID server && \
    adduser --disabled-password --gecos '' --uid $UID --gid $GID server

# Set up a working directory
WORKDIR /home/server/app

# Download and install .NET 7.0 SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh --channel 7.0 --version latest && \
    rm dotnet-install.sh

# Update the PATH environment variable
# Assuming the .NET SDK gets installed under /home/server/.dotnet
ENV PATH="$PATH:/home/server/.dotnet"

# Download and install the game server
RUN wget ${GAME_SERVER_URL} -O game_server.zip && \
    unzip game_server.zip && \
    rm game_server.zip

# Remove unneeded files and packages to reduce Docker image size
RUN apt-get remove -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Change the ownership of the /home/server/app directory to the server user
RUN chown -R server:server /home/server/app

# Switch to the server user
USER server

# Update the CMD instruction to use the full path to the executable
CMD ["/home/server/app/Robust.Server"]
