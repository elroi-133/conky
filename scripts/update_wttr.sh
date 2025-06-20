#!/bin/bash

# Ruta al archivo donde guardarás el resultado
OUTPUT_FILE="$HOME/.cache/wttr_info.txt"

# Consulta y guarda los datos de forma estructurada
DATA=$(curl -s "wttr.in/~Barcelona+venezuela?format=Temp:%t+Vien:%w+Hume:%h+Lluvia:%p+Luna:%m")

# Extrae el ícono de la luna
LUNA_ICON=$(echo "$DATA" | grep -oE "Luna:.*" | cut -d':' -f2)

# Mapea fases lunares a nombres
case "$LUNA_ICON" in
  🌑) LUNA_DESC="Luna Nueva" ;;
  🌒) LUNA_DESC="Creciente Iluminante" ;;
  🌓) LUNA_DESC="Cuarto Creciente" ;;
  🌔) LUNA_DESC="Gibosa Creciente" ;;
  🌕) LUNA_DESC="Luna Llena" ;;
  🌖) LUNA_DESC="Gibosa Menguante" ;;
  🌗) LUNA_DESC="Cuarto Menguante" ;;
  🌘) LUNA_DESC="Menguante Iluminante" ;;
   *) LUNA_DESC="Desconocida" ;;
esac

# Reemplaza el ícono por texto
FORMATTED=$(echo "$DATA" | sed "s/Luna:$LUNA_ICON/Luna: $LUNA_DESC/")

# Guarda el resultado
echo "$FORMATTED" > "$OUTPUT_FILE"

