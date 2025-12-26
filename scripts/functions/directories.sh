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
# TUKAN - Módulo de Directorios
# ============================================================================

manage_directories() {
    local dir_options=("Crear nuevo directorio" "Listar directorios existentes" "Volver")
    
    local selected
    selected=$(printf "%s\n" "${dir_options[@]}" | 
        fzf "${FZF_OPTS[@]}" \
            --prompt="$(render_icon '📁') Directorios > " \
            --border-label="TUKAN - Gestión de Directorios")
    
    case "$selected" in
        "Crear nuevo directorio")
            create_directory
            ;;
        "Listar directorios existentes")
            list_directories
            ;;
    esac
}

create_directory() {
    local new_dir
    new_dir=$(echo "" | 
        fzf --print-query \
            "${FZF_OPTS[@]}" \
            --border-label="TUKAN - Crear Directorio" \
            --prompt="Nombre del directorio > " | head -n1)
    
    if [[ -n "$new_dir" ]]; then
        mkdir -p "$TUKAN_DIR/$new_dir"
        echo "Directorio '$new_dir' creado exitosamente."
        sleep 1
    fi
}

list_directories() {
    local dirs
    dirs=$(find "$TUKAN_DIR" -type d -mindepth 1 | sed "s|$TUKAN_DIR/||" | sort)
    
    # Agregar directorio raíz al principio
    dirs="[raíz]
$dirs"
    
    echo "$dirs" | 
        fzf "${FZF_OPTS[@]}" \
            "${FZF_PREVIEW_OPTS[@]}" \
            --border-label="TUKAN - Directorios Existentes" \
            --prompt="$(render_icon '📁') Directorios > " \
            --preview='
                DIR={}
                if [[ "$DIR" == "[raíz]" ]]; then
                    SEARCH_DIR="'$TUKAN_DIR'"
                    DISPLAY_DIR="Directorio raíz"
                else
                    SEARCH_DIR="'$TUKAN_DIR'/$DIR"
                    DISPLAY_DIR="$DIR"
                fi
                echo -e "\e[1mDirectorio: $DISPLAY_DIR\e[0m"
                echo -e "\e[2m────────────────────────────────────\e[0m"
                echo
                NOTE_COUNT=$(find "$SEARCH_DIR" -maxdepth 1 -type f -name "*.'$TEXT_FORMAT'" 2>/dev/null | wc -l)
                echo -e "\e[1mNotas en este directorio: $NOTE_COUNT\e[0m"
                echo
                if [ $NOTE_COUNT -gt 0 ]; then
                    echo -e "\e[1mContenido:\e[0m"
                    find "$SEARCH_DIR" -maxdepth 1 -type f -name "*.'$TEXT_FORMAT'" 2>/dev/null | sort | while read -r NOTE; do
                        TITLE=$(get_title "$NOTE" | sed "s/://g")
                        FILENAME=$(basename "$NOTE")
                        echo -e "  • \e[36m$FILENAME\e[0m"
                        echo -e "    \e[2m$TITLE\e[0m"
                    done
                else
                    echo -e "  \e[2m(vacío)\e[0m"
                fi
            '
}

# ============================================================================
# FUNCIÓN: MENÚ PARA MOVER NOTAS
# ============================================================================

