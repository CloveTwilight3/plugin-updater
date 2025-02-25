#!/bin/bash
set -e

echo "Starting plugin update..."

# Define the directory where plugins are stored (persistent data directory)
PLUGIN_DIR="/data/plugins"
mkdir -p "$PLUGIN_DIR"

# Plugin download URLs; override these using environment variables if needed.
GEYSER_URL="${GEYSER_URL:-https://ci.opencollab.dev/job/GeyserMC/job/Geyser/job/master/lastSuccessfulBuild/artifact/bootstrap/standalone/target/Geyser.jar}"
FLOODGATE_URL="${FLOODGATE_URL:-https://ci.opencollab.dev/job/GeyserMC/job/Floodgate/job/master/lastSuccessfulBuild/artifact/target/Floodgate.jar}"
VIAVERSION_URL="${VIAVERSION_URL:-https://ci.viaversion.com/job/ViaVersion/lastSuccessfulBuild/artifact/target/ViaVersion.jar}"
VIABACKWARDS_URL="${VIABACKWARDS_URL:-https://ci.viaversion.com/job/ViaBackwards/job/master/lastSuccessfulBuild/artifact/target/ViaBackwards.jar}"

# Define an associative array for plugins and their URLs.
declare -A plugins=(
  ["Geyser"]="$GEYSER_URL"
  ["Floodgate"]="$FLOODGATE_URL"
  ["ViaVersion"]="$VIAVERSION_URL"
  ["ViaBackwards"]="$VIABACKWARDS_URL"
)

# Loop over each plugin and update if there's a newer version available.
for plugin in "${!plugins[@]}"; do
    file="$PLUGIN_DIR/${plugin}.jar"
    echo "Checking update for $plugin..."
    
    if [ -f "$file" ]; then
        echo "Local file exists. Checking for updates..."
        # Use curl's time condition: download only if the remote file is newer.
        curl -L -z "$file" -o "$file" "${plugins[$plugin]}"
    else
        echo "Local file not found. Downloading $plugin..."
        curl -L -o "$file" "${plugins[$plugin]}"
    fi
done

echo "Plugin update process complete!"
