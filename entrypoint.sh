#!/bin/sh

# Define the directory for .NET installation within the user's home directory
DOTNET_INSTALL_DIR="$HOME/.dotnet"

# Download and install .NET 8.0 SDK
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
chmod +x ./dotnet-install.sh
./dotnet-install.sh --install-dir $DOTNET_INSTALL_DIR
rm dotnet-install.sh

# Export the .NET installation path
export DOTNET_ROOT="$DOTNET_INSTALL_DIR"
export PATH="$DOTNET_INSTALL_DIR:$DOTNET_INSTALL_DIR/tools:$PATH"

cd $APP_HOME

# Download the HTML, extract the file URL, download the game server, and cleanup
GAME_SERVER_URL=$(curl -s "https://central.spacestation14.io/builds/wizards/builds.html" | \
    grep -oP "<a href='https://cdn.centcomm.spacestation14.com/builds/wizards/builds/[a-z0-9]+/SS14.Server_linux-x64.zip'>Linux x64</a>" | \
    sed "s|.*href='\(.*\)'.*|\1|")

echo "Extracted URL: $GAME_SERVER_URL"
wget ${GAME_SERVER_URL} -O game_server.zip
unzip -q game_server.zip 
rm game_server.zip

# Ensure the configuration directory exists
mkdir -p "${APP_CONFIG_DIR}"

if [ ! -f "${APP_CONFIG_FILE}" ]; then
    # Attempt to copy the configuration template file to the mounted directory
    if cp "${APP_CONFIG_TEMPLATE_FILE}" "${APP_CONFIG_FILE}"; then
        echo "Configuration file created from default template."
    else
        echo "Failed to copy the configuration file. Please check permissions."
        exit 1
    fi
else
    echo "Configuration file exists already, skipping configuration file creation."
fi

chmod +x ${APP_HOME}/Robust.Server

# Start the server
exec "$@"
