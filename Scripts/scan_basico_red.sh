#!/bin/bash

# ==============================================================================
# Script Sencillo de Nmap para Blue Team: Barrido Básico de Red
#
# Uso: sudo ./scan_basico_red.sh <SUBNET_CIDR>
# Ejemplo: sudo ./scan_basico_red.sh 192.168.1.0/24
#
# Descripción:
# 1. Descubre hosts activos en la subred especificada usando ARP Ping (-PR).
#    (Si falla o no es red local, considera cambiar a -sn normal).
# 2. Escanea los hosts activos con -F (100 puertos TCP comunes) y -sV (versión).
# 3. Guarda los resultados en archivos .nmap y .xml.
#
# Requiere: nmap, awk, grep, y permisos de root (sudo) para -PR y -sS.
# ==============================================================================

# --- Validación de Entrada ---
if [ "$#" -ne 1 ]; then
    echo "❌ Uso: sudo $0 <SUBNET_CIDR>"
    echo "   Ejemplo: sudo $0 192.168.1.0/24"
    exit 1
fi

SUBNET=$1
FECHA=$(date +%Y%m%d)
# Extraer la parte base de la red para nombres de archivo (quita /XX)
NOMBRE_BASE=$(echo "$SUBNET" | sed 's|/.*||')_scan_${FECHA}
ARCHIVO_HOSTS_TEMP="hosts_activos_${NOMBRE_BASE}.tmp"
ARCHIVO_SALIDA_BASE="resultados_${NOMBRE_BASE}" # Nmap añadirá .nmap y .xml

# --- Comprobación de Privilegios ---
if [ "$EUID" -ne 0 ]; then
  echo "⚠️ Este script necesita ejecutarse con privilegios de root (sudo) para usar -PR y -sS."
  # Podrías intentar continuar sin sudo, pero Nmap podría usar -sT en lugar de -sS
  # y fallar con -PR. Por simplicidad, requerimos sudo.
  exit 1
fi

echo "--- Iniciando Barrido Nmap para la red: $SUBNET ---"

# --- 1. Descubrimiento de Hosts (Usando ARP Ping para red local) ---
echo "📡 [Paso 1/3] Descubriendo hosts activos en $SUBNET (usando ARP Ping -PR)..."
# Usamos -oG - para formato grepable, filtramos (-grep), extraemos IP (awk)
sudo nmap -sn -PR -T4 "$SUBNET" -oG - | grep "Status: Up" | awk '{print $2}' > "$ARCHIVO_HOSTS_TEMP"

# Verificar si se encontraron hosts
if [ ! -s "$ARCHIVO_HOSTS_TEMP" ]; then
    echo "🚫 No se encontraron hosts activos en $SUBNET."
    rm "$ARCHIVO_HOSTS_TEMP" # Limpiar archivo temporal vacío
    echo "--- Barrido Nmap Finalizado (Sin hosts activos) ---"
    exit 0
fi

NUM_HOSTS=$(wc -l < "$ARCHIVO_HOSTS_TEMP")
echo "✅ Encontrados $NUM_HOSTS hosts activos. Guardados temporalmente en $ARCHIVO_HOSTS_TEMP."

# --- 2. Escaneo de Puertos y Versiones ---
echo "🚪 [Paso 2/3] Escaneando puertos comunes (-F) y versiones (-sV) en los $NUM_HOSTS hosts activos..."
# -sS: SYN Scan (sigiloso)
# -sV: Detección de versión
# -F:  Fast Scan (100 puertos TCP comunes)
# -T4: Timing Agresivo (razonable para redes internas)
# -iL: Lee los objetivos desde el archivo temporal
# -oA: Guarda en todos los formatos (Normal, XML, Grepable) con el nombre base
sudo nmap -sS -sV -F -T4 -iL "$ARCHIVO_HOSTS_TEMP" -oA "$ARCHIVO_SALIDA_BASE"

echo "✅ Escaneo de puertos y versiones completado."

# --- 3. Limpieza y Finalización ---
echo "🧹 [Paso 3/3] Limpiando archivo temporal..."
rm "$ARCHIVO_HOSTS_TEMP"

echo "--- Barrido Nmap Finalizado ---"
echo "📄 Resultados guardados en:"
echo "   - ${ARCHIVO_SALIDA_BASE}.nmap (Formato Normal)"
echo "   - ${ARCHIVO_SALIDA_BASE}.xml (Formato XML)"
echo "   - ${ARCHIVO_SALIDA_BASE}.gnmap (Formato Grepable)"
echo "--- ¡Revisa los resultados! ---"

exit 0