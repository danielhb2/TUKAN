# 🦜 TUKAN - TU KANBAN (CLI)

[![Bash](https://img.shields.io/badge/bash-5.0+-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-blue.svg)]()  [![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


> **Gestor de notas tipo Kanban con interfaz TUI (Terminal User Interface) interactiva y potente**  
> 
> Este proyecto es una extensión/fork de FuzPad JianZcar - https://github.com/JianZcar/FuzPad.

---

## 📋 ÍNDICE

1. [¿Qué es TUKAN?](#qué-es-tukan)
2. [Características](#características)
3. [Requisitos](#requisitos)
4. [Instalación](#instalación)
5. [Estructura de Archivos](#estructura-de-archivos)
6. [Uso Básico](#uso-básico)
7. [Funciones Principales](#funciones-principales)
8. [Formato de Notas](#formato-de-notas)
9. [Sistema de Etiquetas](#sistema-de-etiquetas)
10. [Directorios](#directorios)
11. [Búsqueda](#búsqueda1)
12. [Estadísticas](#estadísticas)
13. [Configuración](#configuración)
14. [Atajos de Teclado](#atajos-de-teclado)
15. [Arquitectura Modular](#arquitectura-modular)
16. [Troubleshooting](#troubleshooting)
17. [Tips y Consejos](#tips-y-consejos)

---
<a name="qué-es-tukan"></a>
## 🎯 ¿Qué es TUKAN?

TUKAN es un sistema completo de gestión de notas estilo Kanban que funciona completamente en la terminal. Combina la metodología Kanban con un sistema flexible de notas en Markdown, búsqueda interactiva en tiempo real, y una interfaz visual moderna usando `fzf`.

**Filosofía:**
- **Simple**: Archivos markdown planos
- **Rápido**: Navegación con teclado
- **Visual**: Previews en tiempo real
- **Portable**: Solo archivos de texto
- **Sin dependencias**: No requiere base de datos

---
<a name="características"></a>
## ✨ Características

### 🎨 Interfaz
- ✅ Menú interactivo con `fzf`
- ✅ Preview en tiempo real de notas
- ✅ Visualización con colores y formato markdown
- ✅ Navegación completa con teclado

### 📝 Gestión de Notas
- ✅ Crear notas con timestamp automático
- ✅ Editar notas con tu editor favorito
- ✅ Organizar en directorios tipo Kanban
- ✅ Mover notas entre directorios
- ✅ Eliminar notas con confirmación
- ✅ Metadata completa (fechas, tamaño, etiquetas)

### 🔍 Búsqueda y Filtrado
- ✅ Búsqueda en tiempo real (nombres y contenido)
- ✅ Filtrado por etiquetas (#hashtags)
- ✅ Resaltado de coincidencias
- ✅ Preview con contexto

### 📊 Estadísticas
- ✅ Notas por fecha
- ✅ Notas por directorio
- ✅ Filtros temporales (hoy, ayer, semana, mes)
- ✅ Vista general del sistema

### 🏷️ Etiquetas
- ✅ Sistema de hashtags (#etiqueta)
- ✅ Múltiples etiquetas por nota
- ✅ Búsqueda por etiquetas con contador
- ✅ Preview de notas por etiqueta
- ✅ Visualización en metadata

---
<a name="requisitos"></a>
## 📦 Requisitos

### Obligatorios
- `bash` (4.0+)
- `fzf` (0.27+) - Fuzzy finder interactivo
- `find`, `grep`, `sed`, `awk` - Herramientas Unix estándar

### Opcionales (para visualización mejorada)
- `bat` - Resaltado de sintaxis con números de línea
- `mdcat` - Renderizado de markdown en terminal (recomendado)
- `mdless` - Renderizado con paginación

### Instalación de dependencias

**Ubuntu/Debian:**
```bash
sudo apt install fzf bat
cargo install mdcat
```

**macOS:**
```bash
brew install fzf bat
brew install mdcat
```

**Arch Linux:**
```bash
sudo pacman -S fzf bat
cargo install mdcat
```

---
<a name="instalación"></a>
## 🚀 Instalación

### 1. Descargar TUKAN

```bash
# Crear directorio
mkdir -p ~/tukan
cd ~/tukan

# Descargar archivos
# tukan.sh + todos los módulos en functions/
```

### 2. Estructura de directorios

```bash
# Crear subdirectorio para módulos
mkdir -p functions

# Colocar archivos:
# tukan.sh en ~/tukan/
# *.sh en ~/tukan/functions/
```

### 3. Dar permisos de ejecución

```bash
chmod +x tukan.sh
chmod +x functions/*.sh
```

### 4. Ejecutar

```bash
./tukan.sh
```

### 5. Agregar a PATH (opcional)

```bash
# Agregar a ~/.bashrc o ~/.zshrc
export PATH="$HOME/tukan:$PATH"

# Recargar
source ~/.bashrc

# Ahora puedes ejecutar desde cualquier lugar:
tukan.sh
```

---
<a name="estructura-de-archivos"></a>
## 📁 Estructura de Archivos

### Estructura del sistema

```
~/tukan/                          # Instalación de TUKAN
├── tukan.sh                      # Script principal
└── functions/                    # Módulos
    ├── utils.sh                  # Funciones auxiliares
    ├── actions.sh                # Menú de acciones
    ├── help.sh                   # Sistema de ayuda
    ├── search.sh                 # Búsqueda
    ├── tags.sh                   # Etiquetas
    ├── notes.sh                  # Crear/abrir notas
    ├── directories.sh            # Gestión de directorios
    ├── move.sh                   # Mover notas
    ├── stats.sh                  # Estadísticas
    └── delete.sh                 # Eliminar notas


~/Documentos/.TUKAN/              # Directorio de datos
├── 1-Ideas/                      # Ideas nuevas
├── 2-En_curso/                   # Tareas en progreso
├── 3-Terminado/                  # Tareas completadas
├── 4-Cancelado/                  # Tareas canceladas
├── 5-Proyectos_futuros/          # Backlog
├── 6-Notas_varias/               # Se explica solo
├── Basurero/                     # Papelera
├── nota1.md                      # Notas en raíz
└── ...                           # Más notas

📁 Archivo de Configuración

~/.config/tukan/tukan.conf
```

### Ubicación de datos

Por defecto, las notas se guardan en:
```
~/Documentos/.TUKAN/
```

La estructura se genera automáticamente al ejecutar tukan.sh.

Puedes cambiar esta ubicación con la variable de entorno:
```bash
export TUKAN_DIR="$HOME/mis-notas"
```

---
<a name="uso-básico"></a>
## 📖 Uso Básico

### Iniciar TUKAN

```bash
./tukan.sh
```

Se abrirá el menú principal con las siguientes opciones:

```
┌─────────────────────────────────────┐
│ 📕 Nueva                            │
│ 📖 Abrir                            │
│ 🏷 Etiquetas                         │
│ 🔎 Buscar                           │
│ 📁 Directorios                      │
│ 📦 Mover                            │
│ 📊 Estadísticas                     │
│ ❓ Ayuda                            │
│ 🔥 Borrar                           │
│ 💎 Salir                            │
└─────────────────────────────────────┘
```

### Navegación básica

- **↑/↓**: Navegar entre opciones
- **Enter**: Seleccionar opción
- **Esc**: Volver atrás / Salir
- **Tab**: Selección múltiple (donde aplique)

---
<a name="funciones-principales"></a>
## 🎯 Funciones Principales

### 📕 Nueva Nota

Crea una nueva nota con timestamp automático.

**Flujo:**
1. Selecciona directorio de destino
2. Se abre el editor configurado
3. Escribe tu nota en formato Markdown
4. Guarda y cierra el editor

**Nombre automático:**
```
DD-MM-YYYY-HH-MM-SS.md
Ejemplo: 27-01-2025-21-55-01.md
```

**Formato Recomendado**:
```markdown
# Título de la Nota
#etiqueta1 #etiqueta2 #etiqueta3

Contenido de tu nota aquí.
Puedes usar **Markdown** completo.

- Listas
- Código
- Enlaces
```
**Tips**:
- Primera línea: Título (usará este en las listas)
- Segunda línea: Etiquetas (opcional, inicia con # : #etiqueta1)
- Resto: Tu contenido 
---

### 📖 Abrir Nota

Abre y edita notas existentes.

**Características:**
- Lista todas las notas del sistema
- Preview en tiempo real
- Búsqueda interactiva (escribe para filtrar)
- Metadata completa visible

**Metadata mostrada:**
```
┌────────────────────────── METADATA ─────────────────────────┐
│ 27-01-2025-21-55-01.md
│ Directorio: 2-En_curso
│ Creación: 27-01-2025 21:55:01
│ Modificación: 28-01-2025 10:30:15
│ Tamaño: 3.47 KB
│ Etiquetas: #proyecto #importante
└─────────────────────────────────────────────────────────────┘

═══ Título ═══
Mi Proyecto Importante

═══ Contenido ═══
Descripción del proyecto...
```

**Menú de acciones:**
Al seleccionar una nota (Enter):
- **Editar**: Abrir en editor
- **Mover a otro directorio**: Cambiar ubicación
- **Borrar**: Eliminar nota
- **Cancelar**: Volver

---

### 🏷 Etiquetas

Busca y filtra notas por hashtags.

**Características:**
- Lista todas las etiquetas usadas
- Contador de notas por etiqueta
- Preview de notas con esa etiqueta
- Acceso rápido a notas relacionadas

**Cómo Funciona**:
1. El sistema escanea la segunda línea de todas las notas
2. Extrae todos los hashtags (#palabra)
3. Muestra lista de etiquetas únicas
4. Seleccionas una etiqueta
5. Ve todas las notas que la contienen 

**Ejemplo:**
```
#proyecto (15 notas)
#importante (8 notas)
#personal (23 notas)
#trabajo (42 notas)
```

**Flujo:**
1. Selecciona etiqueta
2. Ve lista de notas con esa etiqueta
3. Selecciona nota para ver menú de acciones

**Tips**:
- Usa etiquetas descriptivas: `#trabajo`, `#personal`, `#urgente`
- Combina etiquetas para mejor organización
- No uses espacios en las etiquetas: ~~`#mi etiqueta`~~ → `#mi-etiqueta` 

---

### 🔎 Buscar

Búsqueda en tiempo real en nombres y contenido.

**Características:**
- Búsqueda incremental (resultados al escribir)
- Busca en nombres de archivo
- Busca en contenido de notas
- Resalta coincidencias
- Preview con contexto

**Flujo:**
1. Escribe tu búsqueda (mínimo 2 caracteres)
2. Resultados aparecen automáticamente
3. Navega por resultados
4. Enter para ver menú de acciones

**Formato de resultados:**
```
L42      ║ Este es el texto con la coincidencia... ║ nota.md
ARCHIVO  ║ Coincidencia en nombre                  ║ 27-01-2025.md
```

**Preview muestra:**
- Metadata completa
- Línea exacta de coincidencia resaltada
- Contexto (líneas antes y después)

**Tips**:
- Usa palabras clave específicas
- La búsqueda NO distingue mayúsculas/minúsculas 
---

### 📁 Directorios

Gestiona la estructura de carpetas.

**Submenú**:
```
┌────────────────────────────────────┐
│ Gestión de Directorios             │
├────────────────────────────────────┤
│ Crear nuevo directorio             │
│ Listar directorios existentes      │
│ Volver                             │
└────────────────────────────────────┘
```

#### Crear Directorio

1. Selecciona "Crear nuevo directorio"
2. Escribe el nombre (usa guiones para espacios: `mi-proyecto`)
3. Se crea en la raíz de TUKAN
4. Listo para usar

**Ejemplos**:
```
Clientes/
  Cliente-A/
  Cliente-B/
Proyectos/
  2025/
    Enero/
    Febrero/
```

#### Listar Directorios

- Muestra TODOS los directorios del sistema
- Preview con:
  - Número de notas en el directorio
  - Lista de archivos (nombres y títulos)
- Navegación interactiva 

**Directorios predefinidos:**
- `1-Ideas`: Nuevas ideas y conceptos
- `2-En_curso`: Tareas en progreso
- `3-Terminado`: Tareas completadas
- `4-Cancelado`: Tareas descartadas
- `5-Proyectos_futuros`: Backlog
- `6-Notas_varias`: Se explica solo
- `Basurero`: Papelera de reciclaje
- `[Base]`: Directorio raíz (sin categoría)

---

### 📦 Mover

Reorganiza notas entre directorios.

**Flujo:**
1. Selecciona nota a mover
2. Preview de la nota
3. Selecciona directorio destino
4. Confirmación automática

**Útil para:**
- Mover idea a "En curso"
- Archivar tarea terminada
- Limpiar y organizar
- Workflow Kanban

---

### 📊 Estadísticas

Vista general y análisis del sistema.

**Submenú**:
```
┌────────────────────────────────────────┐
│ Estadísticas                           │
├────────────────────────────────────────┤
│ ⏱️ Ver todas por modificación (↓)      │
│ ⏱️ Ver todas por modificación (↑)      │
│ ⏱️ Ver todas por creación (↓)          │
│ ⏱️ Ver todas por creación (↑)          │
│ 📅 Últimas 24 horas                    │
│ 📆 Últimos 7 días                      │
│ 🗓 Últimos 30 días                     │
│ 📊 Estadísticas generales              │
│ Volver                                 │
└────────────────────────────────────────┘
```

**Opciones:**

#### Vista General
Resumen de notas por directorio:
```
▌ Ideas (5 notas)
────────────────────────────────────
  • Nueva funcionalidad para...
  • Investigar sobre...
  • Propuesta de mejora...
  ... y 2 más

▌ En curso (12 notas)
────────────────────────────────────
  • Proyecto X - Fase 1
  • Documentación de...
  • Implementar feature Y
  ... y 9 más
```

#### Notas por Fecha
- **Por Modificación**: Ordena por última edición
- **Por Creación**: Ordena por fecha de creación original
- **Ascendente/Descendente**: Más nuevas primero o más viejas primero

#### Filtros Temporales

- **24 horas**: Solo notas modificadas hoy
- **7 días**: Trabajo de la semana
- **30 días**: Actividad del mes

#### Estadísticas Generales

Vista completa con:
```
========== ESTADÍSTICAS GENERALES ==========
Ideas                  :  15 notas
En curso              :   8 notas
Terminado             :  42 notas
Cancelado             :   3 notas
Proyectos futuros     :  12 notas
────────────────────────────────────────────
TOTAL                 :  80 notas
────────────────────────────────────────────
Modificadas últimas 24h:   5
```
---

### 🔥 Borrar

Elimina notas con confirmación obligatoria.

**Características:**
- Selección múltiple (Tab)
- Preview antes de borrar
- Confirmación explícita
- Acción irreversible

**Flujo:**
1. Selecciona nota(s) a borrar (Tab para múltiples)
2. Preview de lo que se borrará
3. Escribe "SI" o "S" en MAYÚSCULAS
4. Confirmación de eliminación

**Advertencia visible:**
```
════════════════════════════════════════
  ATENCIÓN: NO SE PUEDE DESHACER
  CONFIRME CON SI O S EN MAYÚSCULAS
════════════════════════════════════════
```

---

### ❓ Ayuda

Sistema de ayuda con secciones.

**Temas disponibles:**
- **Navegación General**: Controles básicos
- **Opciones Principales**: Todas las funciones
- **Atajos**: Comandos de teclado
- **Formato de Notas**: Estructura recomendada
- **Subdirectorios**: Organización
- **Consejos**: Tips y trucos
- **Todo**: Ayuda completa

---
<a name="formato-de-notas"></a>
## 📝 Formato de Notas

### Estructura recomendada

```markdown
# Título de la nota
#etiqueta1 #etiqueta2 #etiqueta3

## Sección 1

Contenido de la sección...

## Sección 2

Más contenido...

- Lista de items
- Otro item

**Texto en negrita**
*Texto en cursiva*
`código inline`

```bash
# Bloque de código
comandoM
'```'
```

### Anatomía de una nota

**Línea 1**: Título principal
```markdown
# Mi Proyecto Importante
```

**Línea 2**: Etiquetas (opcional)
```markdown
#proyecto #trabajo #urgente
```

**Línea 3+**: Contenido
```markdown
Descripción del proyecto...
```

### Buenas prácticas

✅ **Usar títulos descriptivos**
```markdown
# Implementar sistema de autenticación
```

✅ **Etiquetar apropiadamente**
```markdown
#desarrollo #backend #seguridad
```


✅ **Estructurar con secciones**
```markdown
## Objetivo
## Requisitos
## Implementación
## Notas
```

✅ **Usar listas para tareas**
```markdown
- [ ] Tarea pendiente
- [x] Tarea completada
```

---
<a name="sistema-de-etiquetas"></a>
## 🏷️ Sistema de Etiquetas

### Sintaxis

**Formato:**
```markdown
#etiqueta
```

**Reglas:**
- Empieza con `#`
- Sin espacios
- Letras, números, guiones: `#mi-etiqueta_123`
- Case-sensitive: `#Proyecto` ≠ `#proyecto`

### Ubicación

**Segunda línea del archivo:**
```markdown
# Título
#etiqueta1 #etiqueta2 #etiqueta3

Contenido...
```

### Ejemplos de uso

**Por contexto:**
```markdown
#trabajo #personal #estudio
```

**Por proyecto:**
```markdown
#proyecto-x #fase-1 #desarrollo
```

**Por prioridad:**
```markdown
#urgente #importante #bajo-prioridad
```

**Por tipo:**
```markdown
#idea #tarea #nota #referencia
```

**Combinadas:**
```markdown
#trabajo #proyecto-x #urgente #desarrollo
```

### Búsqueda por etiquetas

1. Ir a **🏷 Etiquetas**
2. Seleccionar etiqueta
3. Ver notas filtradas
4. Acceder a nota específica

---
<a name="directorios"></a>
## 📂 Directorios

### Directorios predefinidos

```
~/Documentos/.TUKAN/
├── 1-Ideas/                    # 💡 Nuevas ideas y conceptos
├── 2-En_curso/                 # 🚧 Tareas en progreso
├── 3-Terminado/                # ✅ Tareas completadas
├── 4-Cancelado/                # ❌ Tareas descartadas
├── 5-Proyectos_futuros/        # 📅 Backlog
└── Basurero/                   # 🗑️ Papelera de reciclaje
```

#### 1-Ideas
**Propósito**: Capturar ideas nuevas  
**Uso**: Brainstorming, conceptos iniciales
```
Ideas para nuevos proyectos
Conceptos a investigar
Propuestas sin desarrollo
```

#### 2-En_curso
**Propósito**: Trabajo activo  
**Uso**: Tareas en desarrollo
```
Proyectos activos
Tareas en progreso
Trabajo del día a día
```

#### 3-Terminado
**Propósito**: Archivo de completados  
**Uso**: Historial de logros
```
Proyectos finalizados
Tareas completadas
Referencia histórica
```

#### 4-Cancelado
**Propósito**: Descartados  
**Uso**: Ideas no viables
```
Proyectos cancelados
Ideas descartadas
Tareas obsoletas
```

#### 5-Proyectos_futuros
**Propósito**: Backlog  
**Uso**: Planificación a futuro
```
Ideas para próximos sprints
Proyectos planificados
Objetivos a largo plazo
```

#### 6-Notas_varias
**Propósito**: Acalraciones, datos complementarios, extras    
**Uso**: Lo que se le ocurra  
```
Ideas inconexas
Brainstorming
etc.
```

#### Basurero
**Propósito**: Papelera
**Uso**: Antes de eliminar definitivamente
```
Notas a revisar para borrar
Contenido temporal
Limpieza pendiente
```

#### [Base]
**Propósito**: Sin categorizar
**Uso**: Notas rápidas, sin clasificar
```
Notas temporales
Sin categoría específica
Entrada rápida
```

### Crear directorios personalizados

1. Ir a **📁 Directorios**
2. Seleccionar "Crear nuevo directorio"
3. Escribir nombre
4. Confirmar

**Ejemplos de directorios personalizados:**
```
Clientes/
Proyectos/
  ├── Proyecto-A/
  ├── Proyecto-B/
  └── Proyecto-C/
Referencias/
Templates/
```

---
<a name="búsqueda1"></a>
## 🔍 Búsqueda

### Tipos de búsqueda

#### Búsqueda por nombre 
Encuentra archivos cuyo nombre contiene el término:
```
Buscar: "27"
Resultado: 27-01-2025-21-55-01.md
```

#### Búsqueda por contenido
Encuentra notas que contienen el texto:
```
Buscar: "proyecto"
Resultado: Todas las notas con "proyecto" en contenido
```

#### Búsqueda combinada
TUKAN busca en ambos simultáneamente.

### Consejos de búsqueda

**Términos cortos (2-3 caracteres):**
```
"27" → Encuentra fechas, números
"md" → Encuentra archivos markdown
"py" → Encuentra código Python
```

**Palabras completas:**
```
"proyecto" → Notas sobre proyectos
"urgente" → Tareas urgentes
"backend" → Desarrollo backend
```

**Fechas:**
```
"27-01" → Notas del 27 de enero
"2025" → Notas del año 2025
"01-2025" → Notas de enero 2025
```

### Navegación en resultados

- **↑/↓**: Navegar resultados
- **Enter**: Abrir menú de acciones
- **Esc**: Salir de búsqueda
- **Ctrl+X/Z**: Scroll en preview
- **Ctrl+A/S**: Scroll línea a línea

### Formato de resultados

```
L42      ║ Texto donde aparece la búsqueda...     ║ archivo.md
ARCHIVO  ║ Coincidencia en nombre                 ║ 27-01-2025.md
```

**L42**: Línea 42 del archivo
**ARCHIVO**: Coincidencia en nombre de archivo

---
<a name="estadísticas"></a>
## 📊 Estadísticas

### Vista General

Muestra resumen de todos los directorios:

```
▌ Ideas (5 notas)
────────────────────────────────────
  • Implementar feature X
  • Investigar tecnología Y
  • Propuesta de mejora Z
  ... y 2 más

▌ En curso (12 notas)
────────────────────────────────────
  • Proyecto A - Fase 1
  • Documentación sistema
  • Bug fix crítico
  ... y 9 más
```

**Información mostrada:**
- Nombre del directorio
- Contador de notas
- Preview de últimas 3 notas
- Indicador de más notas

### Notas por Fecha

Lista cronológica de creación:

```
27-01-2025 (5 notas)
26-01-2025 (3 notas)
25-01-2025 (8 notas)
...
```

**Flujo:**
1. Selecciona fecha
2. Ve notas de esa fecha
3. Preview individual
4. Acceso a menú de acciones

### Notas por Período

Filtros temporales rápidos:

#### Hoy
Notas creadas el día actual
```
Útil para: Revisar trabajo del día
```

#### Ayer
Notas creadas ayer
```
Útil para: Seguimiento continuo
```

#### Esta semana
Últimos 7 días
```
Útil para: Review semanal
```

#### Este mes
Mes en curso
```
Útil para: Vista mensual, reportes
```

#### Total
Todas las notas del sistema
```
Útil para: Vista completa, búsqueda general
```

---
<a name="configuración"></a>
## ⚙️ Configuración

TUKAN utiliza un **archivo de configuración externo** para facilitar la personalización sin modificar el código fuente.

### 📁 Archivo de Configuración

**Ubicación:** `~/.config/tukan/tukan.conf`

TUKAN busca automáticamente este archivo al iniciar. Si no existe, usa valores por defecto.

#### Crear configuración

```bash
# Crear directorio de configuración
mkdir -p ~/.config/tukan

# Crear archivo de configuración
nano ~/.config/tukan/tukan.conf
```

#### Ejemplo de tukan.conf

```bash
# ============================================================================
# CONFIGURACIÓN TUKAN
# ============================================================================

# ----------------------------------------------------------------------------
# DIRECTORIOS Y FORMATOS
# ----------------------------------------------------------------------------
TUKAN_DIR="$HOME/Documentos/.TUKAN"
TUKAN_TEXT_FORMAT="md"
EDITOR="nano"
TUKAN_DATE_TIME_FORMAT="%d-%m-%Y-%H-%M-%S"

# ----------------------------------------------------------------------------
# INTERFAZ
# ----------------------------------------------------------------------------
TUKAN_ICON=1
TUKAN_REVERSE_LIST=false
TUKAN_PREVIEW_SIZE="70%"
TUKAN_START_LINE_SEARCH_PREVIEW=5
TUKAN_END_LINE_SEARCH_PREVIEW=9999

# ----------------------------------------------------------------------------
# VISOR DE MARKDOWN
# ----------------------------------------------------------------------------
VISOR="mdcat"           # Opciones: bat, mdcat, mdless, cat
VISOR_STYLE="numbers,grid"  # Solo para bat

# ----------------------------------------------------------------------------
# TEMAS DE COLORES
# ----------------------------------------------------------------------------
# Define tus temas personalizados aquí

AZUL="label:#f2ff00,fg:7,bg:#000080,hl:2,fg+:15,bg+:2,hl+:14,info:3,prompt:2,pointer:#000000,marker:1,spinner:6,border:7,header:2:bold,preview-fg:7,preview-bg:#000000,preview-border:#ffff00"

VERDE="label:#00ff88,fg:7,bg:#001a00,hl:#00ff00,fg+:#ffffff,bg+:#003300,hl+:#88ff00,info:#00cc88,prompt:#00ff88,pointer:#00ff00,marker:#00ff88,spinner:#00cc66,border:#008800,header:#00ff88:bold,preview-fg:#aaffaa,preview-bg:#002200,preview-border:#00ff88"

MATRIX="label:#00ff00,fg:#aaffaa,bg:#000f00,hl:#00ff88,fg+:#ffffff,bg+:#002200,hl+:#88ff00,info:#00aa00,prompt:#00ff00,pointer:#00ff88,marker:#00ff00,spinner:#008800,border:#004400,header:#00ff00:bold,preview-fg:#88ff88,preview-bg:#001900,preview-border:#00aa00"

OSCURO="label:#00ffff,fg:7,bg:#1a1a2e,hl:3,fg+:15,bg+:3,hl+:14,info:6,prompt:4,pointer:#ff00ff,marker:2,spinner:5,border:8,header:4:bold,preview-fg:7,preview-bg:#0f3460,preview-border:#00ffff"

CLARO="label:#000080,fg:0,bg:#f0f0f0,hl:4,fg+:0,bg+:4,hl+:1,info:6,prompt:2,pointer:#000000,marker:1,spinner:6,border:0,header:2:bold,preview-fg:0,preview-bg:#ffffff,preview-border:#000080"

PURPURA="label:#ff79c6,fg:7,bg:#282a36,hl:5,fg+:15,bg+:5,hl+:13,info:6,prompt:13,pointer:#bd93f9,marker:13,spinner:6,border:5,header:13:bold,preview-fg:7,preview-bg:#44475a,preview-border:#ff79c6"

# ----------------------------------------------------------------------------
# TEMA ACTIVO (elige uno de arriba o deja vacío para usar el predeterminado)
# ----------------------------------------------------------------------------
TEMA_ACTIVO="AZUL"
```

### 🎨 Temas de Colores Incluidos

TUKAN incluye múltiples temas predefinidos:

#### Temas Oscuros
- **AZUL** - Azul marino clásico (predeterminado)
- **VERDE** - Verde bosque
- **MATRIX** - Verde Matrix
- **OSCURO** - Oscuro moderno
- **PURPURA** - Púrpura Dracula-like
- **MOKSHA** - Púrpura místico

#### Temas Claros
- **CLARO** - Fondo claro minimalista
- **AGUA_CLARA** - Aqua suave
- **AGUA_FRESCA** - Cyan ligero
- **YETI** - Azul sobre blanco

#### Temas Tierra
- **BOSQUE** - Verde oliva
- **OLIVA** - Oliva natural
- **OCRE_DESIERTO** - Naranja arena
- **CHOCOLATE** - Marrón cálido
- **ARCILLA** - Terracota
- **MIEL** - Amarillo dorado
- **CUERO** - Marrón cuero

#### Tema Nativo
- **NATIVO** - Usa colores del terminal

### 🔧 Personalización Avanzada

#### Crear tu propio tema

```bash
# En ~/.config/tukan/tukan.conf

# Define tu tema personalizado
MI_TEMA="label:#ff00ff,fg:7,bg:#001122,hl:3,fg+:15,bg+:3,hl+:14,info:6,prompt:4,pointer:#00ffff,marker:2,spinner:5,border:8,header:4:bold,preview-fg:7,preview-bg:#002233,preview-border:#ff00ff"

# Actívalo
TEMA_ACTIVO="MI_TEMA"
```

#### Componentes de color fzf

Los temas de fzf se definen con estos componentes:

| Componente | Descripción |
|------------|-------------|
| `label` | Etiqueta del borde |
| `fg` | Texto principal |
| `bg` | Fondo principal |
| `hl` | Resaltado de coincidencias |
| `fg+` | Texto seleccionado |
| `bg+` | Fondo seleccionado |
| `hl+` | Resaltado seleccionado |
| `info` | Información (contador) |
| `prompt` | Símbolo del prompt |
| `pointer` | Puntero de selección |
| `marker` | Marcador (Tab) |
| `spinner` | Spinner de carga |
| `border` | Líneas del borde |
| `header` | Líneas de encabezado |
| `preview-fg` | Texto del preview |
| `preview-bg` | Fondo del preview |
| `preview-border` | Borde del preview |

**Colores:** Usa códigos ANSI (0-255) o hexadecimales (#RRGGBB)

#### Variables configurables

| Variable | Descripción | Por defecto |
|----------|-------------|-------------|
| `TUKAN_DIR` | Directorio de notas | `~/Documentos/.TUKAN` |
| `TUKAN_TEXT_FORMAT` | Extensión de archivos | `md` |
| `EDITOR` | Editor de texto | `nano` |
| `TUKAN_DATE_TIME_FORMAT` | Formato fecha/hora | `%d-%m-%Y-%H-%M-%S` |
| `TUKAN_ICON` | Mostrar iconos (0/1) | `1` |
| `TUKAN_REVERSE_LIST` | Orden inverso | `false` |
| `TUKAN_PREVIEW_SIZE` | Tamaño del preview | `70%` |
| `VISOR` | Visor de markdown | `mdcat` |
| `VISOR_STYLE` | Estilo de bat | `numbers,grid` |
| `TEMA_ACTIVO` | Tema de colores activo | `AZUL` |

### Aplicar cambios

```bash
# Los cambios se aplican al reiniciar TUKAN
./tukan.sh

# O reiniciar terminal si usas variables de entorno
```

---
<a name="atajos-de-teclado"></a>
## ⌨️ Atajos de Teclado

### Navegación general

| Tecla | Acción |
|-------|--------|
| `↑` / `↓` | Navegar opciones |
| `Enter` | Seleccionar |
| `Esc` | Volver / Cancelar |
| `Tab` | Selección múltiple |
| `Ctrl+C` | Salir forzado |

### En preview

| Tecla | Acción |
|-------|--------|
| `Ctrl+X` | Página arriba |
| `Ctrl+Z` | Página abajo |
| `Ctrl+A` | Línea arriba |
| `Ctrl+S` | Línea abajo |

### En búsqueda

| Tecla | Acción |
|-------|--------|
| Escribir | Búsqueda en tiempo real |
| `↑` / `↓` | Navegar resultados |
| `Enter` | Abrir nota |
| `Esc` | Salir de búsqueda |

### En listas

| Tecla | Acción |
|-------|--------|
| Escribir | Filtrar lista |
| `Tab` | Marcar item |
| `Shift+Tab` | Desmarcar item |

---
<a name="arquitectura-modular"></a>
## 🏗️ Arquitectura Modular
> Para mejor depuración en caso de errores, o ampliación/modificación  
### Estructura del sistema

```
tukan/
├── tukan.sh              # Script principal (300 líneas)
│   ├── Configuración
│   ├── Carga de módulos
│   └── Menú principal
└── functions/            # Módulos (1100 líneas)
    ├── utils.sh          # Funciones auxiliares (170 líneas)
    ├── actions.sh        # Menú de acciones (52 líneas)
    ├── help.sh           # Sistema de ayuda (230 líneas)
    ├── search.sh         # Búsqueda (160 líneas)
    ├── tags.sh           # Etiquetas (66 líneas)
    ├── notes.sh          # Crear/abrir (78 líneas)
    ├── directories.sh    # Directorios (80 líneas)
    ├── move.sh           # Mover notas (63 líneas)
    ├── stats.sh          # Estadísticas (340 líneas)
    └── delete.sh         # Eliminar (68 líneas)
```

### Responsabilidades

#### tukan.sh (Principal)
- Configuración global
- Variables de entorno
- Carga de módulos
- Menú principal
- Inicialización

#### utils.sh (Base)
- Funciones auxiliares
- Obtener título
- Obtener etiquetas
- Formatear fechas
- Renderizar iconos
- Preview de Kanban

#### actions.sh
- Menú de acciones de nota
- Editar
- Mover
- Borrar
- Cancelar

#### help.sh
- Sistema de ayuda
- Documentación
- Navegación por secciones

#### search.sh
- Búsqueda en tiempo real
- Nombres de archivo
- Contenido de notas
- Preview con contexto

#### tags.sh
- Listar etiquetas
- Filtrar por etiqueta
- Contador de uso

#### notes.sh
- Crear nueva nota
- Abrir nota existente
- Selección de directorio

#### directories.sh
- Crear directorios
- Listar estructura
- Preview de contenido

#### move.sh
- Mover notas
- Selección de destino
- Confirmación

#### stats.sh
- Vista general
- Notas por fecha
- Notas por período
- Estadísticas globales

#### delete.sh
- Eliminar notas
- Selección múltiple
- Confirmación obligatoria

### Flujo de carga

```
1. tukan.sh inicia
2. Carga configuración
3. Carga utils.sh (base)
4. Carga actions.sh
5. Carga módulos restantes
6. Inicializa directorios
7. Muestra menú principal
```

### Ventajas de la modularización

✅ **Mantenimiento**
- Cada módulo es independiente
- Fácil localizar bugs
- Modificar sin afectar otros

✅ **Desarrollo**
- Trabajar en módulos específicos
- Testing aislado
- Reutilización de código

✅ **Escalabilidad**
- Agregar nuevos módulos
- Extender funcionalidad
- Plugins personalizados

✅ **Claridad**
- Código organizado
- Responsabilidades claras
- Fácil de entender

---
<a name="troubleshooting"></a>
## 🔧 Troubleshooting

### TUKAN no inicia

**Síntoma**: Error al ejecutar `./tukan.sh`

**Solución 1**: Verificar permisos
```bash
chmod +x tukan.sh
chmod +x functions/*.sh
```

**Solución 2**: Verificar estructura
```bash
ls -la
ls -la functions/
# Debe mostrar tukan.sh y functions/*.sh
```

**Solución 3**: Verificar dependencias
```bash
command -v fzf
# Debe mostrar: /usr/bin/fzf o similar

# Si no está instalado:
sudo apt install fzf  # Ubuntu/Debian
brew install fzf      # macOS
```

---

### Error: "Módulo X no encontrado"

**Síntoma**: Mensaje de error al cargar módulos

**Causa**: Archivos faltantes en `functions/`

**Solución**: Verificar todos los módulos
```bash
ls functions/
# Debe listar:
# utils.sh actions.sh help.sh search.sh
# tags.sh notes.sh directories.sh move.sh
# stats.sh delete.sh

# Si falta alguno, descargarlo
```

---

### Preview no se muestra correctamente

**Síntoma**: Preview vacío o con caracteres raros

**Causa**: Visor no instalado o mal configurado

**Solución 1**: Cambiar visor en tukan.sh
```bash
# Editar línea 43
readonly VISOR="cat"  # Más básico, siempre funciona
```

**Solución 2**: Instalar visor
```bash
# mdcat (recomendado)
cargo install mdcat

# bat
sudo apt install bat  # Ubuntu/Debian
brew install bat      # macOS
```

---

### Caracteres especiales mal mostrados

**Síntoma**: Símbolos raros en lugar de caracteres Unicode

**Causa**: Terminal no soporta UTF-8

**Solución**: Configurar locale
```bash
# Verificar locale actual
locale

# Configurar UTF-8
export LANG=es_ES.UTF-8
export LC_ALL=es_ES.UTF-8

# Agregar a ~/.bashrc para que sea permanente
echo 'export LANG=es_ES.UTF-8' >> ~/.bashrc
echo 'export LC_ALL=es_ES.UTF-8' >> ~/.bashrc
```

---

### Búsqueda no encuentra resultados

**Síntoma**: Búsqueda no muestra archivos existentes

**Solución 1**: Verificar directorio
```bash
ls ~/Documentos/.TUKAN/
# Debe mostrar tus notas

# Si está vacío o no existe:
mkdir -p ~/Documentos/.TUKAN
```

**Solución 2**: Verificar TUKAN_DIR
```bash
echo $TUKAN_DIR
# Debe mostrar: /home/usuario/Documentos/.TUKAN

# Si está mal configurado:
export TUKAN_DIR="$HOME/Documentos/.TUKAN"
```

**Solución 3**: Buscar con más caracteres
```bash
# Mínimo 2 caracteres
# "a" → No busca
# "ab" → Sí busca
```

---

### Editor no se abre

**Síntoma**: No pasa nada al seleccionar "Editar"

**Causa**: Editor no configurado o no instalado

**Solución 1**: Verificar editor
```bash
echo $EDITOR
command -v $EDITOR
```

**Solución 2**: Configurar editor
```bash
# En tukan.sh, línea 21
readonly EDITOR=nano

# O usar variable de entorno
export EDITOR=nano
```

**Solución 3**: Instalar editor
```bash
sudo apt install nano  # Ubuntu/Debian
brew install nano      # macOS
```

---

### Notas no se guardan

**Síntoma**: Cambios no persisten

**Causa**: Permisos de escritura

**Solución**: Verificar permisos
```bash
ls -la ~/Documentos/.TUKAN/
# Debe mostrar: drwxr-xr-x

# Si no hay permisos:
chmod -R u+w ~/Documentos/.TUKAN/
```

---

### FZF se cierra inesperadamente

**Síntoma**: Menú se cierra al presionar ciertas teclas

**Causa**: Conflicto de atajos

**Solución**: Evitar estas teclas
- No usar `Ctrl+C` (cierra TUKAN)
- Usar `Esc` para volver atrás
- `Enter` para confirmar

---
<a name="tips-y-consejos"></a>
## 💡 Tips y Consejos

### Workflow recomendado

#### Método GTD (Getting Things Done)

**1. Captura (Ideas)**
```bash
📕 Nueva → Seleccionar "1-Ideas"
Escribir idea rápida
Etiquetar apropiadamente
```

**2. Procesamiento (Clasificación)**
```bash
📖 Abrir → Revisar ideas
📦 Mover → Clasificar por prioridad
```

**3. Organización (Categorización)**
```bash
🏷 Etiquetas → Agrupar por contexto
#trabajo #personal #urgente
```

**4. Ejecución (En curso)**
```bash
📦 Mover → A "2-En_curso"
📖 Abrir → Trabajar en tarea
```

**5. Revisión (Estadísticas)**
```bash
📊 Estadísticas → Ver progreso
Revisar completadas
Ajustar planificación
```

---

### Organización por proyectos

**Crear estructura:**
```bash
📁 Directorios → Crear
Proyectos/
  ├── Proyecto-A/
  ├── Proyecto-B/
  └── Proyecto-C/
```

**Usar etiquetas combinadas:**
```markdown
#proyecto-a #fase-1 #desarrollo
#proyecto-b #diseño #urgente
```

**Mover entre fases:**
```
Ideas → En curso → Terminado
```

---

### Sistema de prioridades

**Usar etiquetas:**
```markdown
#p1-urgente    # Alta prioridad
#p2-importante # Media prioridad
#p3-normal     # Baja prioridad
```

**Buscar por prioridad:**
```bash
🏷 Etiquetas → #p1-urgente
Ver todas las urgentes
```

---

### Backup y sincronización

**Backup manual:**
```bash
# Copiar todo
cp -r ~/Documentos/.TUKAN ~/backup/tukan-$(date +%Y%m%d)

# Comprimir
tar -czf tukan-backup.tar.gz ~/Documentos/.TUKAN
```

**Sincronización con Git:**
```bash
cd ~/Documentos/.TUKAN
git init
git add .
git commit -m "Backup $(date +%Y-%m-%d)"
git push origin main
```

**Sincronización con Dropbox/Drive:**
```bash
# Cambiar ubicación
export TUKAN_DIR="$HOME/Dropbox/TUKAN"

# O crear symlink
ln -s ~/Dropbox/TUKAN ~/Documentos/.TUKAN
```

---

### Templates de notas

**Crear directorio de templates:**
```bash
mkdir ~/Documentos/.TUKAN/Templates/
```

**Template de reunión:**
```markdown
# Reunión: [TEMA]
#reunión #[proyecto]

**Fecha**: DD/MM/YYYY
**Participantes**: 
**Duración**: 

## Agenda
1. 
2. 
3. 

## Notas


## Acciones
- [ ] 
- [ ] 

## Próximos pasos

```

**Template de tarea:**
```markdown
# [NOMBRE DE TAREA]
#tarea #[proyecto] #[prioridad]

## Descripción


## Requisitos
- 
- 

## Pasos
1. 
2. 
3. 

## Notas


## Estado
- [ ] Iniciada
- [ ] En progreso
- [ ] Bloqueada
- [ ] Completada
```

---

### Atajos personalizados

**Agregar alias en ~/.bashrc:**
```bash
# Abrir TUKAN
alias tk="cd ~/tukan && ./tukan.sh"

# Nueva nota rápida
alias tkn="cd ~/tukan && ./tukan.sh nueva"

# Buscar rápido
alias tks="cd ~/tukan && ./tukan.sh buscar"
```

---

### Integración con otras herramientas

**Convertir a HTML:**
```bash
# Usando pandoc
pandoc nota.md -o nota.html
```

**Convertir a PDF:**
```bash
# Usando pandoc
pandoc nota.md -o nota.pdf

# Usando mdpdf
mdpdf nota.md
```

**Ver en navegador:**
```bash
# Usando grip (GitHub markdown preview)
grip nota.md
```

---

### Mantenimiento regular

**Semanal:**
- Revisar notas en "Ideas"
- Mover tareas completadas
- Limpiar "Basurero"
- Actualizar etiquetas

**Mensual:**
- Archivar proyectos terminados
- Revisar estadísticas
- Backup completo
- Reorganizar estructura

---

### Productividad

**Pomodoro con TUKAN:**
```
1. 📖 Abrir → Seleccionar tarea
2. 🍅 25 min de trabajo
3. ✏️ Actualizar nota con progreso
4. ☕ 5 min de descanso
5. Repetir
```

**Review diaria:**
```
Fin del día:
📊 Estadísticas → Hoy
Ver qué se hizo
Planificar mañana
```

**Review semanal:**
```
Viernes:
📊 Estadísticas → Esta semana
Analizar productividad
Ajustar objetivos
```

---

## 📞 Soporte y Contribución

### Reportar bugs

Si encuentras un error:
1. Verifica versión: `./tukan.sh --test`
2. Describe el problema
3. Pasos para reproducir
4. Output de error

### Solicitar features

Sugerencias bienvenidas:
- Nuevas funcionalidades
- Mejoras de UX
- Integraciones
- Optimizaciones

---

## 📄 Licencia

TUKAN es software libre. Úsalo, modifícalo y compártelo libremente.

---

## 🙏 Agradecimientos

Desarrollado con ❤️ para la comunidad de usuarios de terminal.

**Tecnologías usadas:**
- `bash` - Shell scripting
- `fzf` - Fuzzy finder
- `mdcat` - Markdown renderer
- `bat` - Syntax highlighter

---

## 📚 Recursos adicionales

### Documentación externa

- **fzf**: https://github.com/junegunn/fzf
- **bat**: https://github.com/sharkdp/bat
- **mdcat**: https://github.com/swsnr/mdcat
- **Markdown**: https://www.markdownguide.org/

### Tutoriales recomendados

- Bash scripting: https://www.gnu.org/software/bash/manual/
- Metodología Kanban: https://kanbantool.com/kanban-guide
- GTD: https://gettingthingsdone.com/

---

**🦜 TUKAN - TU KANBAN**

*Gestión simple y efectiva de notas y tareas en terminal*

Versión: 1.0 Modular
Última actualización: Diciembre 2025

## 🦜 Sobre TUKAN

TUKAN es una **extensión modular de [Fuzpad](https://github.com/JianZcar/FuzPad)**, 
un gestor de notas para terminal creado por  [JianZcar](https://github.com/JianZcar).

### 🔄 Relación con Fuzpad

TUKAN **hereda y extiende** el código base de Fuzpad, agregando:

- 🏗️ Arquitectura modular (10 módulos independientes)
- 📋 Sistema Kanban con directorios predefinidos
- 📊 Estadísticas y análisis avanzado
- 📦 Gestión completa de directorios
- 🔍 Búsqueda mejorada (nombres + contenido)
- 🏷️ Sistema de etiquetas con contador
- ❓ Sistema de ayuda integrado
- 📋 Preview METADATA unificado

### 📜 Licencia y Créditos

Tanto Fuzpad como TUKAN están licenciados bajo **GPL-3.0**.

**Créditos originales:** [JianZcar](https://github.com/JianZcar/)  
**Desarrollo y extensiones:** [Daniel Horacio Braga]

---

## 📄 Licencia

TUKAN está licenciado bajo **GNU General Public License v3.0**.

Este proyecto es una extensión/fork de [Fuzpad](https://github.com/JianZcar/FuzPad) 
por [JianZcar](https://github.com/JianZcar/), también licenciado bajo GPL-3.0.

### 📋 Términos

- ✅ **Libertad de uso**: Comercial y privado
- ✅ **Libertad de modificar**: Adapta el código a tus necesidades
- ✅ **Libertad de distribuir**: Comparte con otros
- ✅ **Libertad de mejorar**: Contribuye al proyecto

### ⚖️ Condiciones

- 📖 **Código abierto**: Debes compartir el código fuente
- 🔄 **Misma licencia**: Derivados deben usar GPL-3.0
- 📝 **Indicar cambios**: Documenta modificaciones

### 🚫 Limitaciones

- ❌ **Sin garantía**: El software se proporciona "tal cual"
- ❌ **Sin responsabilidad**: Los autores no son responsables de daños

Ver archivo [LICENSE](LICENSE) para el texto legal completo.

---

## 🙏 Créditos

### Basado en Fuzpad
TUKAN es una extensión modular de **[Fuzpad](https://github.com/JianZcar/FuzPad)** desarrollado por [JianZcar](https://github.com/JianZcar).

### Cambios principales
- ✨ Arquitectura modular (10 módulos independientes)
- ✨ Sistema de directorios Kanban
- ✨ Gestión avanzada de etiquetas
- ✨ Estadísticas y análisis
- ✨ Preview METADATA unificado
- ✨ Búsqueda mejorada (nombres y contenido)
- ✨ Archivo de configuración
- ✨ Temas de colores

### Desarrollado por
[Daniel Horacio Braga] - 2025  
Apoyo fundamental de ChatGPT y Claude.ai

### Tecnologías
- `bash` - Shell scripting
- `fzf` - Fuzzy finder
- `mdcat` - Markdown renderer
- `bat` - Syntax highlighter

---

## 🤝 Contribuciones

Las contribuciones son bienvenidas. Al contribuir, aceptas que tu código 
se licencie bajo GPL-3.0.

1. Fork el proyecto
2. Crea tu rama (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add: amazing feature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

---

**TUKAN es Software Libre. Úsalo, estúdialo, compártelo y mejóralo.** 🦜✨


---

## 📦 Estructura final con licencia
```
tukan/
├── LICENSE                    # ← Texto GPL-3.0 completo
├── README.md                  # ← Con sección de licencia y créditos
├── tukan.sh                   # ← Con encabezado GPL
└── functions/
    ├── utils.sh               # ← Con encabezado GPL
    ├── actions.sh             # ← Con encabezado GPL
    ├── help.sh                # ← Con encabezado GPL
    ├── search.sh              # ← Con encabezado GPL
    ├── tags.sh                # ← Con encabezado GPL
    ├── notes.sh               # ← Con encabezado GPL
    ├── directories.sh         # ← Con encabezado GPL
    ├── move.sh                # ← Con encabezado GPL
    ├── stats.sh               # ← Con encabezado GPL
    └── delete.sh              # ← Con encabezado GPL

📁 Archivo de Configuración

~/.config/tukan/tukan.conf
```    
