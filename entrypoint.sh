#!/bin/bash

echo "Generating Xray configs..."

config=$(/usr/bin/generate-configs.sh)

if [[ $LOG_LEVEL == debug ]]; then
    echo "$config" | sed 's/^/\t/'
fi

if [[ $ENCODE_CONFIG == true ]]; then
    config=$(echo "$config" | base64)
fi

echo "$config" > www/output


