#!/bin/bash

echo "Generating Xray configs..."

for server in ${XRAY_SERVERS//[;,]/}; do
    echo "Querying $server..."
    config=$(curl http://$server:81/)
    config=$(sed s/\#/\#$LABEL%20/g <<< $config)
    configs+="$config"$'\n'
done

if [[ $LOG_LEVEL == debug ]]; then
    echo "$configs" | sed 's/^/\t/'
fi

if [[ $ENCODE_CONFIG == true ]]; then
    configs=$(echo "$configs" | base64)
fi

echo "$configs" > www/output


