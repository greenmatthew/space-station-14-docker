FROM debian:bullseye

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y wget curl unzip libicu-dev

ENV UID=568
ENV GID=568

ENV SERVER_BUILDS_PAGE="https://central.spacestation14.io/builds/wizards/builds.html"
ENV SERVER_BUILDS_PAGE_REGEX_PATTERN="<a href='https://cdn.centcomm.spacestation14.com/builds/wizards/builds/[a-z0-9]+/SS14.Server_linux-x64.zip'>Linux x64</a>"

# Create a new group and user
RUN addgroup --gid $GID server && \
    adduser --disabled-password --gecos '' --uid $UID --gid $GID server

# Set up a working directory
WORKDIR /home/server/app

# Download and install .NET 8.0 SDK
RUN wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh && \
    chmod +x ./dotnet-install.sh && \
    ./dotnet-install.sh --channel 8.0 --version latest --install-dir /opt/dotnet && \
    rm dotnet-install.sh

# Update the `root` PATH environment variable
ENV DOTNET_ROOT="/opt/dotnet"
ENV PATH="/opt/dotnet:/opt/dotnet/tools:$PATH"

# Download the HTML, extract the file URL, download the game server, and cleanup
RUN GAME_SERVER_URL=$(curl -s "https://central.spacestation14.io/builds/wizards/builds.html" | \
    grep -oP "<a href='https://cdn.centcomm.spacestation14.com/builds/wizards/builds/[a-z0-9]+/SS14.Server_linux-x64.zip'>Linux x64</a>" | \
    sed "s|.*href='\(.*\)'.*|\1|") && \
    echo "Extracted URL: $GAME_SERVER_URL" && \
    wget ${GAME_SERVER_URL} -O game_server.zip && \
    unzip game_server.zip && \
    rm game_server.zip

# Remove unneeded files and packages to reduce Docker image size
RUN apt-get remove -y wget curl unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Change the ownership of the /home/server/app directory to the server user
RUN chown -R server:server /home/server/app && \
    chmod +x /home/server/app/Robust.Server

# Switch to the server user
USER server

# Update the `server` PATH environment variable
ENV PATH="/opt/dotnet:/opt/dotnet/tools:$PATH"

# Update the CMD instruction to use the full path to the executable
CMD ["/home/server/app/Robust.Server"]
