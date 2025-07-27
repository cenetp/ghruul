#!/bin/bash

path="/usr/local/bin/"
echo "Installing new version of yt-dlp..."
latest_version=$(curl -sL "https://api.github.com/repos/yt-dlp/yt-dlp/releases/latest" | jq -r .tag_name)
curl -LO "https://github.com/yt-dlp/yt-dlp/releases/download/$latest_version/yt-dlp_linux" \
  && mv yt-dlp_linux "$path" && chmod +x "$path/"yt-dlp_linux \
  && echo "Installed yt-dlp_linux $latest_version to: $(which yt-dlp_linux)"
