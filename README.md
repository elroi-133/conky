# 🖥️ Conky Setup - Configuración personalizada de Roissmer

Este proyecto contiene una personalización avanzada de **Conky**, con integración de clima, monitoreo del sistema y un diseño visual atractivo usando **FiraCode Nerd Font** e íconos Unicode.

---

## 🚀 Funcionalidades

- Monitoreo de CPU, RAM, red, disco, batería y clima.
- Íconos Nerd Font para mayor claridad visual.
- Actualización automática del clima usando `wttr.in`.
- Script de instalación para configurar todo desde cero.

---

## 📦 Requisitos

- Linux (preferiblemente basado en Debian/Ubuntu)
- Conky
- `lm-sensors`, `cpufrequtils`
- Acceso a terminal y permisos de superusuario

---

## ⚙️ Instalación rápida

1. **Clona este repositorio:**
   ```bash
   git clone https://github.com/tu_usuario/conky-config.git
   cd conky-config

2. **Ejecuta el instalador:**
   ```bash
   chmod +x setup-conky.sh
   ./setup-conky.sh

3. **Agrega Conky al inicio (opcional):**
   Abre “Aplicaciones al inicio”
   Crea una entrada con:
   Nombre: conky
   Comando: /home/tu_usuario/.start-contry
   Comentario: Monitoreo visual
   Retraso recomendado: 1 segundo
---

## 🌤️ Sobre el clima
   Se consulta wttr.in cada 2 horas a través del script update_wttr.sh, programado automáticamente en crontab.

---

## 🧰 Archivos incluidos
   .conkyrc → Configuración principal
   .start-contry → Script de arranque con retraso
   update_wttr.sh → Script para consultar clima
   FiraCode.zip → Fuente necesaria con íconos
   setup-conky.sh → Instalación automatizada

---

## ✨ Autor
elroi-133 — GitHub