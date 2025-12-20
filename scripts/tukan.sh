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
# TUKAN(ban) - Gestor de Kanban y Notas
# Versión con sistema de configuración externa
# ============================================================================

set -uo pipefail

# ============================================================================
# DETECTAR DIRECTORIO DEL SCRIPT Y MÓDULOS
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FUNCTIONS_DIR="$SCRIPT_DIR/functions"

# ============================================================================
# CONFIGURACIÓN (Cargar desde archivo externo)
# ============================================================================

# Forzar shell compatible
SHELL=/bin/bash

# Cargar configuración del usuario
CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/tukan/tukan.conf"
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
else
    echo "⚠  Configuración no encontrada: $CONFIG_FILE"
    echo "   Usando valores por defecto. Crea el archivo para personalizar."
fi

# Valores por defecto (se sobrescriben desde config si existen)
readonly TUKAN_DIR="${TUKAN_DIR:-"$HOME/Documentos/.TUKAN"}"
readonly TEXT_FORMAT="${TUKAN_TEXT_FORMAT:-"md"}"
readonly EDITOR="${EDITOR:-nano}"
readonly DATE_TIME_FORMAT="${TUKAN_DATE_TIME_FORMAT:-"%d-%m-%Y-%H-%M-%S"}"
readonly ICON=${TUKAN_ICON:-1}
readonly REVERSE_LIST=${TUKAN_REVERSE_LIST:-false}
readonly PREVIEW_SIZE=${TUKAN_PREVIEW_SIZE:-"70%"}
readonly START_LINE_SEARCH_PREVIEW=${TUKAN_START_LINE_SEARCH_PREVIEW:-5}
readonly END_LINE_SEARCH_PREVIEW=${TUKAN_END_LINE_SEARCH_PREVIEW:-9999}

# ============================================================================
# CONFIGURACIÓN DE VISOR
# ============================================================================

readonly VISOR="${VISOR:-"mdless"}"
readonly VISOR_STYLE="${VISOR_STYLE:-"numbers,grid"}"

# Función para ejecutar el visor
view_content() {
    if [[ "$VISOR" == "bat" ]]; then
        bat --style="$VISOR_STYLE" --color=always --paging=never
    else
        $VISOR
    fi
}

# Función para visor con paginación
view_content_paged() {
    if [[ "$VISOR" == "bat" ]]; then
        bat --style="$VISOR_STYLE" --color=always --paging=always "$@"
    elif command -v less &>/dev/null; then
        less -R "$@"
    else
        cat "$@"
    fi
}

export -f view_content
export -f view_content_paged
export VISOR
export VISOR_STYLE

# Directorios de Kanban
readonly KANBAN_DIRS=("1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros" "Basurero")

# ============================================================================
# COLORES FZF (desde configuración)
# ============================================================================

# Expandir el tema activo con evaluación indirecta
if [[ -n "$TEMA_ACTIVO" ]]; then
    readonly FZF_COLORS="${!TEMA_ACTIVO}"
else
    # Tema por defecto
    readonly FZF_COLORS="label:#f2ff00,fg:7,bg:#000080,hl:2,fg+:15,bg+:2,hl+:14,info:3,prompt:2,pointer:#000000,marker:1,spinner:6,border:7,header:2:bold,preview-fg:7,preview-bg:#000000,preview-border:#ffff00"
fi

# Opciones comunes de fzf
readonly FZF_OPTS=(
    --border
    --border-label="TUKAN(ban)"
    --border-label-pos=0
    --ansi
    --cycle
    --pointer=▶
    --marker=+
    --color="$FZF_COLORS"
    --layout=reverse
    --highlight-line
)

# Opciones de preview para fzf
readonly FZF_PREVIEW_OPTS=(
    --bind "ctrl-x:preview-page-up,ctrl-z:preview-page-down"
    --bind "ctrl-a:preview-up,ctrl-s:preview-down"
    --preview-window="down:$PREVIEW_SIZE:noinfo:wrap"
    --preview-label=' [ ctrl-x, ctrl-z, ctrl-a, ctrl-s ] '
)

# ============================================================================
# CARGAR MÓDULOS
# ============================================================================

# Modo test para verificar que el script funciona
[[ "${1:-}" == "--test" ]] && { echo "1"; exit 0; }

# Función para cargar módulos con manejo de errores
load_module() {
    local module_name="$1"
    local module_path="$FUNCTIONS_DIR/$module_name.sh"
    
    if [[ -f "$module_path" ]]; then
        source "$module_path"
        return 0
    else
        echo "⚠️  Advertencia: Módulo $module_name no encontrado"
        echo "   Esperado en: $module_path"
        return 1
    fi
}

# Cargar módulos en orden de dependencias
echo "🔧 Cargando módulos TUKAN..."

# 1. Utilidades (base para todos los demás)
if ! load_module "utils"; then
    echo "❌ ERROR CRÍTICO: El módulo utils.sh es necesario"
    echo "   Crea el directorio y archivos:"
    echo "   mkdir -p functions"
    echo "   # Coloca los módulos en functions/"
    exit 1
fi

# 2. Acciones de notas (usado por varios módulos)
load_module "actions"

# 3. Módulos principales
load_module "help"
load_module "search"
load_module "tags"
load_module "notes"
load_module "directories"
load_module "move"
load_module "stats"
load_module "delete"

echo "✓ Módulos cargados correctamente"
echo ""

# ============================================================================
# INICIALIZACIÓN
# ============================================================================

# Crear estructura de directorios si no existe
init_directories() {
    [[ ! -d "$TUKAN_DIR" ]] && mkdir -p "$TUKAN_DIR"
    
    for dir in "${KANBAN_DIRS[@]}"; do
        [[ ! -d "$TUKAN_DIR/$dir" ]] && mkdir -p "$TUKAN_DIR/$dir"
    done
}

init_directories

# ============================================================================
# MENÚ PRINCIPAL
# ============================================================================

show_menu() {
    while true; do
        local option
        option=$(echo -e "$(render_icon '📕') Nueva\n$(render_icon '📖') Abrir\n$(render_icon '🏷') Etiquetas\n$(render_icon '🔎') Buscar\n$(render_icon '📁') Directorios\n$(render_icon '📦') Mover\n$(render_icon '📊') Estadísticas\n$(render_icon '❓') Ayuda\n$(render_icon '🔥') Borrar\n$(render_icon '💎') Salir" | 
            fzf "${FZF_OPTS[@]}" \
                "${FZF_PREVIEW_OPTS[@]}" \
                --prompt="Menú Principal > " \
                --preview='
                    OPTION=$(echo {} | sed "s/^[^ ]* //")
                    case "$OPTION" in
                        "Nueva") 
                            echo -e "\e[1;32m📕 Crear Nueva Nota      \e[0m"
                            echo
                            echo "Crea una nueva nota con:"
                            echo "• Timestamp automático"
                            echo "• Editor de texto configurado"
                            echo "• Formato markdown"
                            ;;
                        "Abrir") 
                            echo -e "\e[1;34m📖 Abrir Notas Existentes\e[0m"
                            echo
                            echo "Explora y edita tus notas:"
                            echo "• Búsqueda interactiva"
                            echo "• Preview en tiempo real"
                            echo "• Ordenación personalizable"
                            ;;
                        "Etiquetas") 
                            echo -e "\e[1;33m🏷 Buscar por Etiquetas  \e[0m"
                            echo
                            echo "Filtra notas por #hashtags"
                            ;;
                        "Buscar") 
                            echo -e "\e[1;32m🔎 Búsqueda de Texto     \e[0m"
                            echo
                            echo "Busca contenido dentro de tus notas"
                            echo "• Búsqueda interactiva en tiempo real"
                            echo "• Resultados mientras escribes"
                            echo "• Preview con contexto"
                            ;;
                        "Directorios")
                            echo -e "\e[1;33m📁 Gestión de Directorios\e[0m"
                            echo
                            echo "Crear nuevas categorías"
                            echo "• Crear directorios"
                            echo "• Listar directorios existentes"
                            ;;
                        "Mover")
                            echo -e "\e[1;35m📦 Mover Notas           \e[0m"
                            echo
                            echo "Reorganiza tus notas entre directorios"
                            ;;
                        "Estadísticas")
                            echo -e "\e[1;36m📊 Vista de Estadísticas \e[0m"
                            echo
                            generate_kanban_preview
                            ;;
                        "Ayuda")
                            cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                     ? SISTEMA DE AYUDA                    ║
╚═══════════════════════════════════════════════════════════╝

📚 Centro de ayuda completo de TUKAN

🎯 Qué encontrarás:
   • Navegación General - Controles básicos
   • Opciones Principales - Todas las funciones
   • Atajos de Teclado - Comandos rápidos
   • Formato de Notas - Cómo escribir notas
   • Subdirectorios - Organización
   • Consejos - Tips y trucos

💡 Presiona Enter para acceder a la ayuda interactiva
   con navegación por secciones.

EOF
                            ;;
                        "Borrar")
                            echo -e "\e[1;31m🔥 Eliminar Notas\e[0m"
                            echo
                            echo -e "\e[91m⚠ Acción irreversible\e[0m"
                            ;;
                        "Salir")
                            echo -e "\e[1;35m💎 Salir de TUKAN\e[0m"
                            echo
                            echo "Hasta pronto!"
                            ;;
                    esac
                ')
        
        [[ -z "$option" ]] && break
        
        # Procesar opción seleccionada
        case "$option" in
            *"Nueva"*) new_note ;;
            *"Abrir"*) open_note ;;
            *"Etiquetas"*) open_tags ;;
            *"Buscar"*) search_notes ;;
            *"Directorios"*) manage_directories ;;
            *"Mover"*) move_notes_menu ;;
            *"Estadísticas"*) show_statistics ;;
            *"Ayuda"*) show_help ;;
            *"Borrar"*) delete_notes ;;
            *"Salir"*) break ;;
        esac
    done
clear ; tput setaf 2 bold ; echo "Gracias por usar TUKAN" ; echo -e "\e[1;35m   💎 Hasta pronto \e[0m"
}

# ============================================================================
# INICIO
# ============================================================================

show_menu
