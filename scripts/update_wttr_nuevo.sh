#!/bin/bash

# Asegurar HOME si no está definido
[ -z "$HOME" ] && export HOME=$(getent passwd "$(id -un)" | cut -d: -f6)

# Crear carpeta si no existe
CACHE_DIR="$HOME/.cache"
mkdir -p "$CACHE_DIR"
OUTPUT_FILE="$CACHE_DIR/wttr_info.txt"

# Obtener JSON completo
WTTR_JSON=$(curl -s "wttr.in/~Barcelona+venezuela?format=j1")

# Extraer datos clave
TEMP=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].temp_C')
FEELS=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].FeelsLikeC')
HUM=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].humidity')
WIND=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].windspeedKmph')
PRECIP=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].precipMM')
UV=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].uvIndex')
VIS=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].visibility')
DESC=$(echo "$WTTR_JSON" | jq -r '.current_condition[0].weatherDesc[0].value')

# Astronomía
SUNRISE=$(echo "$WTTR_JSON" | jq -r '.weather[0].astronomy[0].sunrise')
SUNSET=$(echo "$WTTR_JSON" | jq -r '.weather[0].astronomy[0].sunset')
MOON_PHASE_EN=$(echo "$WTTR_JSON" | jq -r '.weather[0].astronomy[0].moon_phase')
MOON_ILLUM=$(echo "$WTTR_JSON" | jq -r '.weather[0].astronomy[0].moon_illumination')

# Traducir fase lunar
case "$MOON_PHASE_EN" in
  "New Moon") MOON=" Luna Nueva" ;;
  "Waxing Crescent") MOON=" Creciente Iluminante" ;;
  "First Quarter") MOON=" Cuarto Creciente" ;;
  "Waxing Gibbous") MOON=" Gibosa Creciente" ;;
  "Full Moon") MOON=" Luna Llena" ;;
  "Waning Gibbous") MOON=" Gibosa Menguante" ;;
  "Last Quarter") MOON=" Cuarto Menguante" ;;
  "Waning Crescent") MOON=" Menguante Iluminante" ;;
  *) MOON="🌘 Desconocida" ;;
esac

# Probabilidad máxima de lluvia del día
MAXRAIN=$(echo "$WTTR_JSON" | grep -o '"chanceofrain":"[0-9]*"' | cut -d':' -f2 | tr -d '"' | sort -nr | head -n1)

# Construir archivo final
{
  echo " Temp: $TEMP°C (Sensación: $FEELS°C)"
  echo " Humedad: $HUM%    Viento: $WIND km/h"
  echo " Lluvia: ${MAXRAIN}%     Precipitación: ${PRECIP}mm"
  echo "  UV: $UV     Visibilidad: $VIS km"
  echo "󱣹 Clima: $DESC"
  echo "  Amanecer: $SUNRISE   󰖚 Atardecer: $SUNSET"
  echo "󰽧 Fase Lunar: $MOON   󰌵 Iluminación: ${MOON_ILLUM}%"
} > "$OUTPUT_FILE"

