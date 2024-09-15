#!/bin/sh
# Script to upload a file that was blocked by Santa using curl.

BLOCKED_FILEPATH=`./santa-dndump | jq '.file_path' | tr -d '"'`
curl -X POST -H "Content-Type: application/octet-stream" --data-binary "@$BLOCKED_FILEPATH" http://localhost:8080
