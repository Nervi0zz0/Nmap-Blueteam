# 🛡️ Nmap Esencial para Blue Team: Visibilidad y Defensa Activa 🛡️

**¡Bienvenido a la Guía Esencial de Nmap para Equipos de Defensa (Blue Team)!**

Esta guía te proporciona una base sólida y práctica para utilizar Nmap, una herramienta indispensable en ciberseguridad, enfocándonos en cómo fortalece tus capacidades defensivas. Olvídate del ruido inicial, aquí encontrarás claridad, ejemplos prácticos y un enfoque visual para dominar lo fundamental.

> **⚠️ ¡LA REGLA DE ORO: AUTORIZACIÓN! ⚠️**
> Nmap interactúa activamente con la red. **JAMÁS** ejecutes Nmap contra ningún sistema o red sin **autorización explícita, documentada y por escrito** del propietario. El escaneo no autorizado es ilegal, poco ético y puede tener consecuencias graves. ¡Actúa siempre con responsabilidad y profesionalidad!

---

## 🤔 ¿Por Qué Nmap es Clave en el Arsenal del Blue Team?

Nmap no es solo para atacantes. Para un Blue Team, es una herramienta fundamental de **visibilidad y verificación**. Te permite validar la postura de seguridad de tu red de forma proactiva, ayudándote a:

* **✅ Validar Inventarios y Descubrir "Shadow IT":** Confirma qué dispositivos están realmente activos y conectados, comparándolo con tu inventario oficial y detectando sistemas no registrados.
* **🚪 Auditar la Superficie de Exposición:** Identifica qué puertos están abiertos y qué servicios están escuchando. ¿Hay algo expuesto innecesariamente?
* **🔍 Identificar Servicios y Versiones:** No solo veas un puerto abierto, ¡identifica qué software y versión específica se ejecuta! Esto es crucial para la gestión de vulnerabilidades.
* **🧱 Verificar la Segmentación y Firewalls:** Comprueba que tus controles de red (Firewalls, ACLs) funcionan como esperas, bloqueando el tráfico no deseado entre segmentos.
* **🔄 Detectar Cambios y Derivas:** Comparando escaneos periódicos, puedes detectar nuevas aperturas de puertos o cambios en servicios que podrían indicar una mala configuración o un compromiso.

---

## 🚀 Primeros Pasos: Instalación

Nmap es multiplataforma. Aquí las formas comunes de instalarlo:

* **Linux (Debian/Ubuntu):** `sudo apt update && sudo apt install nmap`
* **Linux (Fedora/CentOS):** `sudo dnf install nmap` (o `yum`)
* **macOS (con Homebrew):** `brew install nmap`
* **Windows:** Descarga el instalador `exe` oficial (Nmap setup) desde [nmap.org/download.html](https://nmap.org/download.html)

*(Recuerda: Muchos comandos potentes de Nmap requieren privilegios de administrador/root, por lo que usarás `sudo` en Linux/macOS)*

---

## ✨ Conceptos Fundamentales (La Base de Todo) ✨

Entender estos conceptos te permitirá usar Nmap con confianza:

1.  **🎯 Objetivo (`target`):** A quién escaneas. Puede ser una IP (`192.168.1.1`), un nombre de host (`servidor.local`), un rango (`10.0.0.1-20`), una subred completa en notación CIDR (`192.168.1.0/24`) o leer desde un archivo (`-iL lista_hosts.txt`). ¡Define siempre un alcance claro y **autorizado**!
2.  **📡 Descubrimiento de Hosts (`Host Discovery`):** El paso previo para saber si un objetivo está "vivo" y responde en la red. La opción `-sn` se usa para hacer *solo* esto, sin escanear puertos. `-PR` (ARP Ping) es muy rápido en redes locales. `-Pn` *evita* este paso (¡úsalo con cuidado!).
3.  **🚪 Escaneo de Puertos (`Port Scanning`):** La función estrella. Averigua el estado de los puertos TCP y UDP. Los estados clave son:
    * `open`: ¡Hay un servicio escuchando activamente! (Tu foco principal).
    * `closed`: El puerto responde, pero no hay servicio escuchando. (Confirma que el host está vivo).
    * `filtered`: Nmap no puede determinar el estado; probablemente un firewall está bloqueando. (Indica control de red).
4.  **🔍 Identificación Servicio/Versión (`Service/Version Detection -sV`):** Una vez encontrado un puerto `open`, Nmap intenta averiguar qué aplicación concreta (ej. Apache, Microsoft IIS, OpenSSH) y qué **versión** está corriendo. ¡Oro puro para detectar software vulnerable!
5.  **⏱️ Temporización (`Timing -T<0-5>`):** Controla la velocidad y agresividad del escaneo. `-T4` (agresivo) suele ser bueno para redes internas rápidas y fiables. `-T3` (normal) es el defecto. `-T0` a `-T2` son más lentos y sigilosos. `-T5` (insane) es muy rápido pero puede sobrecargar redes o ser detectado. Empieza con `-T3` o `-T4` en redes locales.
6.  **💾 Guardar Resultados (`Output`):** ¡Fundamental! Guarda tus hallazgos. `-oN <fichero.nmap>` para formato legible. `-oX <fichero.xml>` para formato XML (ideal para procesar con herramientas como `ndiff` o scripts). `-oA <base_fichero>` guarda en Normal, XML y Grepable a la vez.

---

## 🛡️ Comandos Nmap Esenciales para Defensa (Ejemplos Prácticos) 🛡️

Aquí tienes recetas básicas para tareas comunes del Blue Team:

### 1. Inventario Rápido de Red Local (Descubrimiento)

* **Objetivo:** Listar rápidamente IPs activas en tu segmento de red local.
* **Comando:**
    ```bash
    # -sn: No escanear puertos, solo descubrir.
    # -PR: Método ARP Ping (rápido y fiable en local).
    # -T4: Timing agresivo para acelerar.
    sudo nmap -sn -PR -T4 192.168.1.0/24
    ```
* **Fíjate en:** Las líneas `Host is up` te dan las IPs activas.

### 2. Chequeo Rápido de Puertos Comunes en un Host

* **Objetivo:** Ver si un host específico tiene abiertos los puertos TCP más típicos.
* **Comando:**
    ```bash
    # -F: Fast Scan (100 puertos TCP más comunes).
    # -T4: Timing agresivo.
    sudo nmap -F -T4 192.168.1.10
    ```
* **Fíjate en:** La tabla de puertos. ¿Hay algo `open` que no esperabas?

### 3. Escaneo de Puertos TCP Específicos + Versión

* **Objetivo:** Verificar puertos clave (Web, SSH, RDP) y saber qué servicio/versión corre si están abiertos.
* **Comando:**
    ```bash
    # -sS: SYN Scan (sigiloso, necesita sudo).
    # -sV: Detección de Servicio/Versión ¡Importante!
    # -p T:22,80,443,3389: Puertos TCP específicos a escanear.
    # -T4: Timing agresivo.
    sudo nmap -sS -sV -p T:22,80,443,3389 -T4 192.168.1.15
    ```
* **Fíjate en:** Estado (`open`/`closed`/`filtered`), `SERVICE` (ej. http, ssh) y `VERSION` (ej. Apache httpd 2.4.41, OpenSSH 8.2p1).

### 4. Escaneo Más Completo (Top 1000 Puertos + Versión) y Guardado

* **Objetivo:** Un escaneo más profundo de los 1000 puertos TCP más comunes, con detección de versión, guardando los resultados.
* **Comando:**
    ```bash
    # --top-ports 1000: Alternativa a -F, escanea más puertos comunes.
    # -sV: Detección de versión.
    # -oA <base_fichero>: Guarda en .nmap, .xml, .gnmap
    # $(date +%Y%m%d): Añade la fecha al nombre del archivo.
    sudo nmap -sS -sV --top-ports 1000 -T4 192.168.1.0/24 -oA scan_red_completo_$(date +%Y%m%d)
    ```
* **Fíjate en:** Los archivos generados (`.nmap`, `.xml`, `.gnmap`) y su contenido detallado. El XML es especialmente útil para análisis posteriores.

---

## 🤔 Interpretando los Resultados: Más Allá de los Datos

Nmap te da información valiosa, pero **la inteligencia la aportas tú**. Al revisar los resultados, pregúntate:

* **¿Es esperado?** ¿Debería este host estar aquí? ¿Debería este puerto estar abierto según nuestras políticas y la función del sistema?
* **¿Es vulnerable?** La versión del servicio detectada (`-sV`) ¿tiene vulnerabilidades conocidas (CVEs)? (Necesitarás cruzar esta info con bases de datos de CVEs).
* **¿Viola la política?** ¿Permite un protocolo inseguro (ej. Telnet abierto)? ¿Expone información sensible?
* **¿Ha cambiado?** Si comparas con escaneos anteriores (`ndiff` con salida XML), ¿qué ha cambiado y por qué?

> **💡 Consejo:** Integra los resultados de Nmap en tu proceso general de gestión de activos, vulnerabilidades y monitorización. No es una herramienta aislada.

---

## 🛠️ Herramienta Adicional: Script de Barrido Básico

Para poner en práctica lo aprendido, hemos incluido un script simple en la carpeta `/scripts` (`scan_basico_red.sh`) que automatiza un barrido básico de red:

1.  Descubre hosts activos en una subred (`-PR`).
2.  Escanea los puertos comunes (`-F`) y versiones (`-sV`) de esos hosts.
3.  Guarda los resultados (`-oA`).

**Uso (¡Siempre con autorización!):**

```bash
# 1. Ve a la carpeta del script
cd scripts/

# 2. Dale permisos de ejecución (solo la primera vez)
chmod +x scan_basico_red.sh

# 3. Ejecútalo con sudo y tu subred autorizada
sudo ./scan_basico_red.sh <TU_SUBNET_AUTORIZADA_CIDR>
# Ejemplo: sudo ./scan_basico_red.sh 192.168.1.0/24