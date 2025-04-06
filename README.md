# 🛡️ Nmap Esencial para Blue Team: Tu Primera Defensa 🛡️

**¡Bienvenido/a!** Esta guía es una introducción **clara y visual** a cómo usar Nmap, una herramienta increíblemente útil, desde la perspectiva de la **defensa (Blue Team)**. Olvídate de la complejidad inicial, ¡vamos a lo esencial!

> **⚠️ ¡LO MÁS IMPORTANTE: PERMISO! ⚠️**
> Nmap es potente. **NUNCA** escanees una red o dispositivo sin tener **permiso explícito y por escrito**. Es ilegal y poco ético. ¡Escanea sólo lo que te autoricen!

---

## 🤔 ¿Por Qué Nmap si Soy Defensor (Blue Team)?

Imagina Nmap como tus "ojos" en la red. Te ayuda a:

* **✅ Verificar tu Inventario:** ¿Qué equipos están realmente conectados y activos?
* **🚪 Comprobar Puertos Abiertos:** ¿Hay "puertas" abiertas (servicios) que no deberían estarlo?
* **🔍 Identificar Servicios:** Saber qué programas (y a veces su versión) están detrás de esos puertos abiertos.
* **🧱 Auditar Reglas de Firewall:** Comprobar si el firewall está bloqueando lo que debe bloquear.

---

## 🚀 Primeros Pasos (Instalación Rápida)

Nmap funciona en Linux, macOS y Windows. La forma más fácil suele ser:

* **Linux (Debian/Ubuntu):** `sudo apt update && sudo apt install nmap`
* **Linux (Fedora/CentOS):** `sudo dnf install nmap` (o `yum`)
* **macOS (con Homebrew):** `brew install nmap`
* **Windows:** Descarga el instalador desde [nmap.org](https://nmap.org/download.html) (Instalador `exe`).

*(Para comandos que usan `sudo`, necesitarás permisos de administrador)*

---

## ✨ Conceptos Clave (¡Lo Mínimo que Necesitas!) ✨

1.  **🎯 Objetivo (`target`):** A quién vas a escanear (una IP `192.168.1.1`, un rango `192.168.1.1-50`, o una red `192.168.1.0/24`).
2.  **📡 Descubrir (`Host Discovery`):** Averiguar si el objetivo está "vivo" antes de escanearlo a fondo (`-sn`).
3.  **🚪 Escanear Puertos (`Port Scanning`):** Ver qué puertos TCP o UDP están `open` (abierto), `closed` (cerrado) o `filtered` (filtrado por firewall).
4.  **🔍 Identificar Servicio/Versión (`Service/Version Detection`):** Intentar saber qué programa y versión corre en un puerto abierto (`-sV`).
5.  **💾 Guardar Resultados (`Output`):** Salvar lo que encuentras en un archivo (`-oN`, `-oX`).

---

## 🛡️ Tareas Esenciales del Blue Team con Nmap 🛡️

Aquí tienes los comandos básicos para empezar:

### 1. Encontrar Equipos Activos en tu Red Local (`-sn`)

* **Objetivo:** Hacer un inventario rápido de qué IPs responden en tu red local.
* **Comando:**
    ```bash
    # -sn: Solo descubre hosts (Ping Scan), no escanea puertos. Rápido!
    # -PR: Usa ARP Ping (muy fiable en red local). Necesita sudo.
    sudo nmap -sn -PR 192.168.1.0/24
    ```
* **Qué buscar:** Las líneas que dicen `Host is up`.

### 2. Comprobar Puertos Comunes en un Equipo Específico (`-F`)

* **Objetivo:** Ver rápidamente si un equipo tiene abiertos los puertos más habituales.
* **Comando:**
    ```bash
    # -F: Fast Scan (escanea los 100 puertos TCP más comunes).
    nmap -F 192.168.1.10
    ```
* **Qué buscar:** Puertos en estado `open`. ¿Son los que esperabas?

### 3. Escanear Puertos TCP Específicos (`-p T:<puertos>`)

* **Objetivo:** Verificar si ciertos puertos TCP están abiertos, cerrados o filtrados.
* **Comando:**
    ```bash
    # -p T:22,80,443,3389 : Escanea solo los puertos TCP 22 (SSH), 80 (HTTP), 443 (HTTPS), 3389 (RDP).
    # -sS: TCP SYN Scan (sigiloso, necesita sudo). Si no puedes usar sudo, Nmap usará -sT (menos sigiloso).
    sudo nmap -sS -p T:22,80,443,3389 192.168.1.15
    ```
* **Qué buscar:** El estado (`open`, `closed`, `filtered`) de cada puerto.

### 4. Identificar Servicio y Versión en Puertos Abiertos (`-sV`)

* **Objetivo:** Saber qué programa y versión corre en los puertos abiertos encontrados. ¡Muy importante!
* **Comando:**
    ```bash
    # -sV: Habilita la detección de versión en los puertos abiertos.
    # Combinado con -F para escanear puertos comunes y obtener versión.
    sudo nmap -sV -F 192.168.1.20
    ```
* **Qué buscar:** La columna `VERSION`. ¿Es una versión antigua o vulnerable? ¿Es el servicio esperado?

### 5. Guardar los Resultados en un Archivo (`-oN`, `-oX`)

* **Objetivo:** Guardar el escaneo para revisarlo luego o compararlo.
* **Comando:**
    ```bash
    # -oN <archivo.nmap>: Guarda en formato normal, legible por humanos.
    sudo nmap -sV -F 192.168.1.0/24 -oN escaneo_red_$(date +%Y%m%d).nmap

    # -oX <archivo.xml>: Guarda en formato XML, ideal para procesar con otros programas o comparar (ndiff).
    sudo nmap -sV -F 192.168.1.0/24 -oX escaneo_red_$(date +%Y%m%d).xml
    ```
* **Qué buscar:** Los archivos generados (`.nmap` o `.xml`) en tu carpeta.

---

## 📋 Resumen Rápido de Opciones Clave

| Opción        | Qué Hace (Simplificado)                                  | Uso Blue Team Principal                             |
| :------------ | :------------------------------------------------------- | :-------------------------------------------------- |
| `<target>`    | Especifica a quién escanear (IP, Rango, Red)             | Definir el alcance **autorizado** |
| `-sn`         | Sólo descubre hosts activos, no escanea puertos        | Inventario rápido de red                            |
| `-PR`         | Usa ARP para descubrir hosts (sólo red local)            | Descubrimiento **muy rápido** en tu segmento local    |
| `-F`          | Escanea los 100 puertos TCP más comunes                 | Chequeo rápido de puertos habituales              |
| `-p <puertos>`| Escanea sólo los puertos TCP/UDP que especifiques        | Verificar puertos específicos (ej. 80, 443, 3389) |
| `-sS`         | Escaneo TCP SYN (sigiloso, necesita `sudo`)              | El escaneo TCP recomendado si puedes usar `sudo`  |
| `-sV`         | Intenta identificar versión del servicio en puertos abiertos | **Crucial:** Saber qué software/versión está expuesto |
| `-oN <fich>`  | Guarda la salida en formato legible                     | Revisión manual, informes simples                 |
| `-oX <fich>`  | Guarda la salida en formato XML                         | Automatización, comparación, análisis avanzado     |

---

## ✅ Consideraciones Finales (¡Importante!)

* **Autorización SIEMPRE:** Ya lo hemos dicho, pero es vital. Ten permiso escrito.
* **Empieza Simple:** No uses opciones avanzadas o agresivas (`-T5`, `-A`) hasta que entiendas bien qué hacen y tengas permiso. Podrías afectar a la red.
* **Comunica:** Si vas a escanear una red corporativa, informa a tus compañeros o responsables.
* **Interpreta:** Nmap te da datos. Tú debes interpretarlos en el contexto de tu red y políticas. ¿Un puerto abierto es normal o anómalo?

---

## 📚 Siguientes Pasos

¡Esto es sólo el principio! Si quieres profundizar más:

* Ejecuta `nmap --help` en tu terminal para ver un resumen de opciones.
* Consulta la [Guía de Referencia Oficial de Nmap](https://nmap.org/book/man.html) (en inglés, ¡pero es la fuente definitiva!).
* ¡Experimenta en un entorno **controlado y autorizado** (como máquinas virtuales propias)!

**¡Feliz (y ético) escaneo!**
