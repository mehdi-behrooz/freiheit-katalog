#!/bin/bash

echo "Generating Xray configs..."

configs=$(/usr/bin/generate-configs.sh)

if [[ $LOG_LEVEL == debug ]]; then
    echo "$configs" | sed 's/^/\t/'
fi

echo "$configs" | base64 > www/index.html


