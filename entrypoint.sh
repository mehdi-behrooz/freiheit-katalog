#!/bin/bash

echo "Generating Xray configs..."

for server in ${XRAY_SERVERS//[;,]/}; do
    echo "Querying $server..."
    config=$(
        curl --retry 20 \
            --retry-connrefused \
            --retry-delay 3 \
            "http://$server:81/"
    )
    config=${config//\#/\#$LABEL%20}
    configs+="$config"$'\n'
done

if [[ $LOG_LEVEL == debug ]]; then
    sed 's/^/\t/g' <<<"$configs"
fi

if [[ $ENCODE_CONFIG == true ]]; then
    configs=$(echo "$configs" | base64)
fi

mkdir -p /www
echo "$configs" >/www/output
