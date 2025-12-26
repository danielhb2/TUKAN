#!/bin/bash
# TUKAN - TU KANBAN
# Sistema de gestión de notas tipo Kanban para terminal
#
# Copyright (C) 2025 [Daniel Horacio Braga]
# Based on Fuzpad by [JianZcar]
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
# ============================================================================
# TUKAN - Módulo de Ayuda
# ============================================================================

# Contenido de la ayuda
readonly HELP_TEXT='# Ayuda de TUKAN(ban) - o sea TU KANBAN
Gestor de kanban y de notas en general

## Navegación General
- Use las flechas ↑/↓ para navegar entre opciones
- Presione Enter para seleccionar
- Presione Esc para volver al menú anterior

## Opciones Principales
- 📕 Nueva: Crea una nueva nota con fecha y hora automática
  - La primera línea será el título  
  - La segunda línea es para las etiquetas  
  - Puedes elegir en qué subdirectorio guardarla
- 📖 Abrir: Explora y abre notas existentes
- 🏷 Etiquetas: Busca notas por etiquetas (#hashtags)
  - La segunda línea, cada etiqueta inicia con # (#etiqueta)  
  - separadas por espacios: #etiqueta1 #etiqueta2, etc.
- 🔎 Buscar: Busca texto dentro de las notas
- 📁 Directorios: Crear nuevos subdirectorios
- 📦 Mover notas a otros directorios
- 📊 Estadísticas: Ver notas por fecha y estadísticas
- ❓ Ayuda: Muestra esta pantalla de ayuda
- 🔥 Borrar: Elimina notas (selección múltiple con Tab)
- 💎 Salir: Cierra TUKAN

## Atajos en Vistas de Previsualización
- Ctrl+S: desplaza una línea hacia abajo
- Ctrl+A: desplaza una línea hacia arriba
- Ctrl+X: Página arriba en la previsualización
- Ctrl+Z: Página abajo en la previsualización
- **En la Previsualización**  
- Recuadro con la metadata del archivo  
- Primera línea real del archivo
> Generalmente formato título  
- Si hay etiquetas se ven en la línea siguiente
> (Segunda línea del archivo)
- El resto del archivo  

**EJEMPLO DE VISUALIZACIÓN**
~~~
┌────────────────────────── METADATA ─────────────────────────┐
│ 26-11-2025-00-58-00.md	(nombre del archivo)
│ Directorio: 2-En_curso
│ Creación: 28-11-2025 20:10:25
│ Modificación: 29:11:2025 01:10:30
│ Etiquetas: #etiqueta1 #etiqueta2
└─────────────────────────────────────────────────────────────┘

# Primer título		-> La primera línea real del archivo
#etiqueta1 #etiqueta2	-> con dos espacios al final de la línea

Este es el contenido del archivo.
Es sólo un ejemplo.
~~~

## Formato de Notas
- Primera línea: Título de la nota
- Segunda línea: Etiquetas (#hashtag1 #hashtag2)
- Resto: Contenido de la nota

## Subdirectorios
**Predefinidos**  
- Directorio base
  - 1-Ideas: Nuevas ideas y conceptos
  - 2-En_curso: Tareas en progreso
  - 3-Terminado: Tareas completadas
  - 4-Cancelado: Tareas descartadas
  - 5-Proyectos_futuros: Backlog
  - Basurero: Papelera de reciclaje

> Las notas pueden organizarse en subdirectorios  
> Al crear una nota, puedes elegir el directorio  
> Todas las funciones trabajan con subdirectorios  

## Consejos
- En el modo borrar, puede seleccionar múltiples notas usando Tab
- Para confirmar el borrado escriba '\''SI'\'' o '\''S'\'' (en mayúsculas)
- Para buscar, simplemente comience a escribir su consulta
- 📊 Estadísticas: Ver notas por fecha y estadísticas'

# Exportar para uso en subshells
export HELP_TEXT

# ============================================================================
# FUNCIÓN: MOSTRAR AYUDA
# ============================================================================

show_help() {
    local help_topics=(
        "Navegación General:Uso básico de teclas y controles"
        "Opciones Principales:Descripción de cada función"
        "Atajos:Atajos de teclado en previsualizaciones"
        "Formato de Notas:Estructura recomendada para notas"
        "Subdirectorios:Organización en carpetas"
        "Consejos:Tips para usar TUKAN eficientemente"
        "Todo:Mostrar toda la ayuda"
    )
    
    printf "%s\n" "${help_topics[@]}" | 
        fzf "${FZF_OPTS[@]}" \
            "${FZF_PREVIEW_OPTS[@]}" \
            --border-label="Ayuda de TUKAN" \
            --prompt="$(render_icon '❓')Seleccione tema > " \
            --bind 'start:down+up' \
            --preview='
                LINE={}
                
                # Si no hay línea seleccionada o está vacía, mostrar resumen general
                if [[ -z "$LINE" ]]; then
                    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║              📚 CENTRO DE AYUDA - TUKAN                   ║
╚═══════════════════════════════════════════════════════════╝

Bienvenido al sistema de ayuda de TUKAN.

🎯 NAVEGACIÓN:
   • Usa ↑↓ para moverte entre temas
   • Presiona Enter para ver el tema completo
   • Presiona Esc para volver al menú

📖 TEMAS DISPONIBLES:

   📍 Navegación General
      Aprende a moverte por TUKAN y usar controles básicos

   📋 Opciones Principales
      Descripción detallada de cada función del menú

   ⌨️  Atajos
      Atajos de teclado en vistas de previsualización

   📝 Formato de Notas
      Estructura recomendada para tus notas

   📁 Subdirectorios
      Cómo organizar tus notas en carpetas

   💡 Consejos
      Tips para usar TUKAN eficientemente

   📚 Todo
      Muestra toda la ayuda completa

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Consejo: Selecciona un tema arriba para ver su contenido
   en este panel de previsualización.

EOF
                    exit 0
                fi
                                 
                # Extraer tema de la línea seleccionada
                IFS=":" read -r TOPIC DESC <<< "$LINE"
                
                case "$TOPIC" in
                    "Navegación General")
                        echo "# Navegación General" | view_content
                        echo "$HELP_TEXT" | sed -n "/^## Navegación General/,/^##/p" | sed "/^##[^#]/d" | view_content
                        ;;
                    "Opciones Principales")
                        echo "# Opciones Principales" | view_content
                        echo "$HELP_TEXT" | sed -n "/^## Opciones Principales/,/^##/p" | sed "/^##[^#]/d" | view_content
                        ;;
                    "Atajos")
                        echo "# Atajos en Vistas de Previsualización" | view_content
                        echo "$HELP_TEXT" | sed -n "/^## Atajos/,/^##/p" | sed "/^##[^#]/d" | view_content
                        ;;
                    "Formato de Notas")
                        echo "# Formato de Notas" | view_content
                        echo "$HELP_TEXT" | sed -n "/^## Formato de Notas/,/^##/p" | sed "/^##[^#]/d" | view_content
                        ;;
                    "Subdirectorios")
                        echo "# Subdirectorios" | view_content
                        echo "$HELP_TEXT" | sed -n "/^## Subdirectorios/,/^##/p" | sed "/^##[^#]/d" | view_content
                        ;;
                    "Estadísticas")
                        echo "# Estadísticas" | view_content
                        echo "$HELP_TEXT" | sed -n "/^## Estadísticas/,/^##/p" | sed "/^##[^#]/d" | view_content
                        ;;
                    "Consejos")
                        echo "# Consejos" | view_content
                        echo "$HELP_TEXT" | sed -n "/^## Consejos/,/^##/p" | sed "/^##[^#]/d" | view_content
                        ;;
                    "Todo")
                        echo "$HELP_TEXT" | view_content
                        ;;
                esac
            '
}