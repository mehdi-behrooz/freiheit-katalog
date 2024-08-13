#!/bin/bash

TCP='vless://$user@$host:443?encryption=none&security=none&type=tcp&headerType=none#$label'

WS='vless://$user@$host:443?encryption=none&security=tls&sni=$sni&alpn=h2&fp=chrome&type=ws&host=$sni&path=$path#$label'

REALITY='vless://$user@$host:443?encryption=none&flow=xtls-rprx-vision&security=reality&sni=$sni&alpn=http%2F1.1&fp=chrome&pbk=$public_key&type=tcp&headerType=none#$label'

encode() {
    printf "$1" | jq -sRr '@uri';
}

generate() {
    for condition in "${@:4}"; do
        if [[ $condition -eq 0 ]]; then
            return 0
        fi
    done
    export user=$2
    export label=$(encode "$LABEL $3")
    url=$(envsubst <<<$1)
    echo $url
}


if [[ $XRAY_TCP_ENABLED == true ]]; then tcp=1; else tcp=0; fi
if [[ $XRAY_WS_ENABLED == true ]]; then ws=1; else ws=0; fi
if [[ $XRAY_REALITY_ENABLED == true ]]; then reality=1; else reality=0; fi
if [[ $WARP_ENABLED == true ]]; then warp=1; else warp=0; fi
if [[ $TUNNEL_ENABLED == true ]]; then tunnel=1; else tunnel=0; fi;
if [[ -n $CLOUDFLARE_WORKER ]]; then worker=1; else worker=0; fi

export host=$TEHRAN_DOMAIN

generate $TCP $XRAY_TCP_USER_ID_DIRECT "Tunnel" $tcp $tunel
generate $TCP $XRAY_TCP_USER_ID_WARP "Tunnel Warp" $tcp $tunnel $warp

export host=$CLOUDFLARE_IP
export sni=$XRAY_WS_HOST
export path=$XRAY_WS_PATH

generate $WS $XRAY_WS_USER_ID_DIRECT "WS" $ws
generate $WS $XRAY_WS_USER_ID_WARP "WS Warp" $ws $warp

export host=$CLOUDFLARE_IP
export sni=$CLOUDFLARE_WORKER
export path=$XRAY_WS_PATH

generate $WS $XRAY_WS_USER_ID_DIRECT "Worker" $ws $worker
generate $WS $XRAY_WS_USER_ID_WARP "Worker Warp" $ws $worker $warp

export host=$(curl -s6 ip.sb || curl -s4 ip.sb)
export sni=$XRAY_REALITY_SNI
export public_key=$XRAY_REALITY_PUBLIC_KEY

generate $REALITY $XRAY_REALITY_USER_ID_DIRECT "Reality" $reality
generate $REALITY $XRAY_REALITY_USER_ID_WARP "Reality Warp" $reality $warp

