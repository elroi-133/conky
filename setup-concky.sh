#!/bin/bash

WORKDIR=$(pwd)
FONTS_DIR="$HOME/.local/share/fonts"

echo "🔄 Comprobando si Conky está instalado..."
if ! command -v conky &> /dev/null; then
    echo "🛠️ Instalando conky-all..."
    sudo apt-get update
    sudo apt-get install -y conky-all
else
    echo "✅ Conky ya está instalado."
fi

echo "📁 Verificando archivos fuente..."
if [ ! -f "$WORKDIR/.conkyrc" ] || [ ! -f "$WORKDIR/.start-conky" ]; then
    echo "❌ Faltan '.conkyrc' o '.start-conky' en $WORKDIR"
    exit 1
fi

echo "📦 Copiando archivos .conkyrc y .start-conky al home"
cp "$WORKDIR/.conkyrc" "$HOME/.conkyrc"
cp "$WORKDIR/.start-conky" "$HOME/.start-conky"
chmod +x "$HOME/.start-conky"

echo "🌐 Detectando interfaz WiFi..."
WIFI_IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^wl' | head -n 1)
if [ -n "$WIFI_IFACE" ]; then
    sed -i "s/wlp2s0/$WIFI_IFACE/g" "$HOME/.conkyrc"
    echo "✏️ Interfaz detectada: $WIFI_IFACE"
else
    echo "⚠️ No se detectó interfaz WiFi. Edita ~/.conkyrc manualmente si es necesario."
fi

echo "🧱 Instalando paquetes adicionales"
sudo apt-get install -y lm-sensors cpufrequtils

echo "🧱 Instalando paquetes adicionales"
sudo apt-get install -y jq

# Manejo de dpkg roto
sudo dpkg --configure -a 2>/dev/null || echo "⚠️ Ejecuta manualmente: sudo dpkg --configure -a"

echo "🧠 Obteniendo información de RAM"
sudo dmidecode --type memory > "$HOME/ram_info.txt"

# ─────── FiraCode Nerd Font ─────── #
echo "🔤 Instalando FiraCode Nerd Font..."
if [ -f "$WORKDIR/fonts/FiraCode.zip" ]; then
    mkdir -p "$FONTS_DIR"
    unzip -o "$WORKDIR/fonts/FiraCode.zip" -d "$FONTS_DIR"
    fc-cache -fv
    echo "✅ Fuentes instaladas:"
    fc-list | grep "FiraCode"
else
    echo "⚠️ FiraCode.zip no encontrado en $WORKDIR"
fi

# ─────── Script update_wttr ─────── #
echo "☁️ Configurando script 'update_wttr.sh'..."
if [ -f "$WORKDIR/scripts/update_wttr_nuevo.sh" ]; then
    cp "$WORKDIR/scripts/update_wttr_nuevo.sh" "$HOME/update_wttr_nuevo.sh"
    chmod +x "$HOME/update_wttr_nuevo.sh"
    crontab -l | grep -q "update_wttr_nuevo.sh" || (crontab -l 2>/dev/null; echo "0 */2 * * * $HOME/update_wttr_nuevo.sh") | crontab -
    echo "⏱️ Script 'update_wttr_nuevo.sh' programado para ejecutarse cada 2 horas."
else
    echo "⚠️ No se encontró 'update_wttr_nuevo.sh' en $WORKDIR"
fi

echo ""
echo "🎯 ¡Listo! Solo te falta agregar Conky a inicio automático (si no lo hiciste aún):"
echo "- Nombre: conky"
echo "- Orden: $HOME/.start-conky"
echo "- Comentario: conky"
echo "- Retraso: 1 segundo (opcional)"
