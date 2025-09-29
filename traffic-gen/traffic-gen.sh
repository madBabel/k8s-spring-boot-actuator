#!/bin/sh

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <target> <interval-in-seconds>"
    exit 1
fi

TARGET=$1
INTERVAL=$2



NC="\033[0m" # Reset de color

echo "Sending requests to $TARGET every $INTERVAL seconds."



while true; do
    REQUEST_TIME=$(date +"%Y-%m-%d %H:%M:%S")
    RESPONSE=$(curl -s "$TARGET")

    STATUS=$?

    if [ $STATUS -ne 0 ]; then
        echo "[$REQUEST_TIME] ❌ error connecting $TARGET ( $STATUS-$RESPONSE)"    
    else
        LAST8="${RESPONSE: -8}"

        # Calcular hash numérico del reactor
        HASH=$(printf "%s" "$LAST8" | cksum | awk '{print $1}')

        #HASH=$(echo -n "$RESPONSE" | cksum | awk '{print $1}')
        COLOR_CODE=$(( (HASH % 10) + 90 )) # 10 colores distintos dentro del rango ANSI "90–99" (10 valores)

        COLOR="\033[0;${COLOR_CODE}m"

        echo -e "${COLOR}[$REQUEST_TIME] $RESPONSE${NC}"
    fi

    sleep $INTERVAL
done