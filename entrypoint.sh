#!/bin/bash

indent() { sed 's/^/  /'; }

echo "Generating Xray configs..."

for server in ${XRAY_SERVERS//[;,]/}; do
    echo "Querying $server..."
    config=$(
        curl -s --retry 20 \
            --retry-connrefused \
            --retry-delay 3 \
            "http://$server:81/"
    )
    config=${config//\#/\#$LABEL%20}
    configs+="$config"$'\n'
done

if [[ $LOG_LEVEL == debug ]]; then
    echo "$configs" | indent
fi

if [[ $ENCODE_CONFIG == true ]]; then
    configs=$(echo "$configs" | base64)
fi

mkdir -p /www
echo "$configs" >/www/output
