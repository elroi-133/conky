#!/bin/bash

# Definir manualmente HOME si no existe
if [ -z "$HOME" ]; then
  export HOME=$(getent passwd "$(id -un)" | cut -d: -f6)
fi

# Asegurar que exista la ruta ~/.cache
mkdir -p "$HOME/.cache"

# Ruta de salida
OUTPUT_FILE="$HOME/.cache/wttr_info.txt"

# Asegura que el directorio exista
mkdir -p "$(dirname "$OUTPUT_FILE")"

# Descarga y analiza la info del clima
DATA=$(curl -s "wttr.in/~Barcelona+venezuela?format=Temp:%t+Hume:%h+Vien:%w+\\nLluvia:%p+Luna:%m")
ICON=$(echo "$DATA" | grep -o "Luna:.*" | cut -d':' -f2)

case "$ICON" in
  🌑) PHASE="Luna Nueva" ;;
  🌒) PHASE="Creciente Iluminante" ;;
  🌓) PHASE="Cuarto Creciente" ;;
  🌔) PHASE="Gibosa Creciente" ;;
  🌕) PHASE="Luna Llena" ;;
  🌖) PHASE="Gibosa Menguante" ;;
  🌗) PHASE="Cuarto Menguante" ;;
  🌘) PHASE="Menguante Iluminante" ;;
   *) PHASE="Desconocida" ;;
esac

# Consulta JSON para probabilidad máxima de lluvia
MAXRAIN=$(curl -s "wttr.in/~Barcelona+venezuela?format=j1" | grep -o '"chanceofrain":"[0-9]*"' | cut -d':' -f2 | tr -d '"' | sort -nr | head -n1)

# Sustituir campo “Lluvia” por la probabilidad calculada
DATA=$(echo "$DATA" | sed "s/Lluvia:[^+]*+/Lluvia:${MAXRAIN}%+/")

# Integrar fase lunar
FORMATTED=$(echo "$DATA" | sed "s/Luna:$ICON/Luna: $PHASE/")

echo -e "$FORMATTED" > "$OUTPUT_FILE"
