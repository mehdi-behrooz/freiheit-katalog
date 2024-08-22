#!/bin/bash

echo "Generating Xray configs..."

for server in ${XRAY_SERVERS//[;,]/}; do
    echo "Querying $server..."
    config=$(curl --retry 20 \
                  --retry-connrefused \
                  --retry-delay 3 \
                  http://$server:81/
    )
    config=$(sed s/\#/\#$LABEL%20/g <<< $config)
    configs+="$config"$'\n'
done

if [[ $LOG_LEVEL == debug ]]; then
    echo "$configs" | sed 's/^/\t/'
fi

if [[ $ENCODE_CONFIG == true ]]; then
    configs=$(echo "$configs" | base64)
fi

mkdir -p /www
echo "$configs" > /www/output


