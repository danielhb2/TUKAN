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
# TUKAN - Módulo de Utilidades
# Funciones auxiliares usadas por todos los módulos
# ============================================================================

# Repetir caracteres (optimizado)
repeat_char() {
    printf '%*s' "$2" | tr ' ' "$1"
}

# Obtener fecha y hora actual
get_current_date_time() {
    date +"$DATE_TIME_FORMAT"
}

# Determinar orden de lista
list_order() {
    [[ "$REVERSE_LIST" != "true" ]] && echo "--tac"
}

# Renderizar iconos con colores (optimizado con array asociativo)
render_icon() {
    [[ "$ICON" -ne 1 ]] && return
    
    local icon="$1"
    case "$icon" in
        📕) echo -e "\e[38;5;196m📕\e[0m" ;;  # rojo
        📖) echo -e "\e[38;5;33m📖\e[0m" ;;   # azul
        🏷) echo -e "\e[38;5;208m🏷\e[0m" ;;  # naranja
        🔎) echo -e "\e[38;5;82m🔎\e[0m" ;;   # verde
        📁) echo -e "\e[38;5;226m📁\e[0m" ;;  # amarillo
        📦) echo -e "\e[38;5;172m📦\e[0m" ;;  # naranja paquete
        📊) echo -e "\e[38;5;141m📊\e[0m" ;;  # púrpura estadísticas
        🔥) echo -e "\e[38;5;202m🔥\e[0m" ;;  # naranja fuego
        ❓) echo -e "\e[38;5;5m❓\e[0m" ;;    # morado ayuda
        💎) echo -e "\e[38;5;219m💎\e[0m" ;;  # rosado salida
        *) echo "$icon" ;;
    esac
}

# Obtener título de la nota (línea 1 o 2 si hay shebang)
get_title() {
    local file="$1"
    local first_line
    first_line=$(head -n1 "$file")
    
    if [[ $first_line == "#!"* ]]; then
        sed -n '2p' "$file"
    else
        echo "$first_line"
    fi
}

# Obtener etiquetas de la nota
get_tags() {
    local file="$1"
    local first_line
    first_line=$(head -n1 "$file")
    
    if [[ $first_line == "#!"* ]]; then
        sed -n '3p' "$file"
    else
        sed -n '2p' "$file"
    fi
}

# Listar todas las notas recursivamente (optimizado)
list_all_notes() {
    find "$TUKAN_DIR" -type f -name "*.$TEXT_FORMAT" -printf '%P\n' 2>/dev/null
}

# Obtener solo el nombre del archivo
get_filename() {
    basename "$1"
}

# Obtener directorio relativo
get_relative_dir() {
    local dir
    dir=$(dirname "$1")
    [[ "$dir" == "." ]] && echo "Directorio: Base" || echo "Directorio: $dir"
}

# Obtener fecha de modificación (optimizado)
get_mod_date() {
    local file="$1"
    [[ ! -f "$file" ]] && return
    
    # Linux
    if stat -c %y "$file" 2>/dev/null | awk '{print $1" "$2}' | sed 's/\([0-9]\{4\}\)-\([0-9]\{2\}\)-\([0-9]\{2\}\)/\3-\2-\1/' | cut -d'.' -f1; then
        return
    fi
    # macOS fallback
    stat -f "%Sm" -t "%d-%m-%Y %H:%M:%S" "$file" 2>/dev/null
}

# Obtener fecha de creación
get_creation_date() {
    local file="$1"
    [[ ! -f "$file" ]] && return
    
    # Linux
    local birth_time
    if birth_time=$(stat -c %W "$file" 2>/dev/null); then
        if [[ "$birth_time" != "0" ]]; then
            date -d "@$birth_time" "+%d-%m-%Y %H:%M:%S" 2>/dev/null && return
        fi
        # Fallback a mtime
        stat -c %y "$file" 2>/dev/null | cut -d' ' -f1,2 | cut -d'.' -f1 && return
    fi
    # macOS
    stat -f "%SB" -t "%d-%m-%Y %H:%M:%S" "$file" 2>/dev/null
}

# Obtener tamaño del archivo
get_file_size() {
    local file="$1"
    [[ ! -f "$file" ]] && return
    
    # Obtener tamaño en bytes
    local bytes=$(stat -c %s "$file" 2>/dev/null || stat -f %z "$file" 2>/dev/null)
    
    # Convertir a KB con 2 decimales
    echo "scale=2; $bytes / 1024" | bc | awk '{printf "%.2f KB", $1}'
}

export -f get_file_size

# Generar preview de Kanban (optimizado)
generate_kanban_preview() {
    local dir dir_path note_count display_name
    
    for dir in "1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros"; do
        dir_path="$TUKAN_DIR/$dir"
        [[ ! -d "$dir_path" ]] && continue
        
        note_count=$(find "$dir_path" -maxdepth 1 -type f -name "*.$TEXT_FORMAT" 2>/dev/null | wc -l)
        display_name=$(echo "$dir" | sed 's/^[0-9]-//' | tr '_' ' ')
        
        echo -e "\e[1;36m▌ $display_name\e[0m \e[2m($note_count notas)\e[0m"
        echo -e "\e[2m────────────────────────────────────\e[0m"
        
        if ((note_count > 0)); then
            find "$dir_path" -maxdepth 1 -type f -name "*.$TEXT_FORMAT" 2>/dev/null | 
                sort -r | head -n 3 | while read -r note; do
                    local title
                    title=$(get_title "$note" | sed "s/://g" | head -c 40)
                    echo -e "  • \e[33m$title\e[0m"
                done
            
            ((note_count > 3)) && echo -e "  \e[2m  ... y $((note_count - 3)) más\e[0m"
        else
            echo -e "  \e[2m(vacío)\e[0m"
        fi
        echo
    done
}

# Exportar funciones para uso en subshells
export -f get_title get_tags get_filename get_relative_dir
export -f get_mod_date get_creation_date generate_kanban_preview repeat_char
export -f render_icon list_order get_current_date_time list_all_notes
