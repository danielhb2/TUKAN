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
# TUKAN - Módulo de Mover Notas
# ============================================================================

move_note() {
    local note="$1"
    local filename
    filename=$(basename "$note")
    
    # Obtener lista de directorios
    local dirs
    dirs=$(find "$TUKAN_DIR" -type d -not -path "$TUKAN_DIR" | sed "s|$TUKAN_DIR/||" | sort)
    
    local target_dir
    target_dir=$(echo "$dirs" | 
        fzf "${FZF_OPTS[@]}" \
            --prompt="$(render_icon '📦') Mover a > " \
            --preview="
                DIR='$TUKAN_DIR/{}'
                echo -e \"\e[1mDirectorio destino:\e[0m {}\"
                echo
                COUNT=\$(find \"\$DIR\" -maxdepth 1 -type f -name '*.$TEXT_FORMAT' 2>/dev/null | wc -l)
                echo -e \"\e[2mNotas actuales: \$COUNT\e[0m\"
            ")
    
    if [[ -n "$target_dir" ]]; then
        local dest="$TUKAN_DIR/$target_dir/$filename"
        
        # Verificar si existe archivo con el mismo nombre
        if [[ -f "$dest" ]]; then
            echo "Ya existe un archivo con ese nombre en el destino"
            return 1
        fi
        
        mv "$note" "$dest"
        echo "Nota movida a: $target_dir"
    fi
}

# ============================================================================
# FUNCIÓN: MOSTRAR MENÚ PRINCIPAL
# ============================================================================

move_notes_menu() {
    local note_data
    note_data=$(list_all_notes | while read -r note; do
        echo "$(get_title "$TUKAN_DIR/$note" | sed "s/://g"):$note"
    done | 
        fzf "${FZF_OPTS[@]}" \
            "${FZF_PREVIEW_OPTS[@]}" \
            $(list_order) \
            --prompt="$(render_icon '📦') Seleccionar nota a mover > " \
            --preview='
                IFS=":" read -r TITLE NOTE <<< {}
                FILENAME=$(basename "$NOTE")
                RELDIR=$(get_relative_dir "$NOTE")
                FILESIZE=$(get_file_size "'$TUKAN_DIR'/$NOTE")
# Extraer hashtags
HASHTAGS=$(sed -n "2p" "'$TUKAN_DIR'/$NOTE" | grep -o "#[[:alnum:]_-]\+" | tr "\n" " " | sed "s/[[:space:]]*$//")
if [[ -z "$HASHTAGS" ]]; then
    HASHTAGS_DISPLAY="\e[2mSin etiquetas\e[0m"
else
    HASHTAGS_DISPLAY="\e[1;35m$HASHTAGS\e[0m"
fi

echo -e "\e[1;36m┌────────────────────────── METADATA ─────────────────────────┐\e[0m"
echo -e "\e[1;36m│\e[0m \e[1m$FILENAME\e[0m"
echo -e "\e[1;36m│\e[0m \e[2m$RELDIR\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mCreación: $CREATEDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mModificación: $MODDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
echo -e "\e[1;36m│\e[0m Etiquetas: $HASHTAGS_DISPLAY"
echo -e "\e[1;36m└─────────────────────────────────────────────────────────────┘\e[0m"
echo
echo -e "\e[1;35m═══ Título ═══\e[0m"
echo -e "\e[1m$TITLE\e[0m" | view_content
echo
echo -e "\e[1;35m═══ Contenido ═══\e[0m"
sed "1{/^#!/ { n; n; d; }; d; }; /^#[[:alnum:]_-]/{/^#[^!]/d}" "'$TUKAN_DIR'/$NOTE" | view_content
            ')
    
    if [[ -n "$note_data" ]]; then
        IFS=":" read -r title note <<< "$note_data"
        move_note "$TUKAN_DIR/$note"
    fi
}

# ============================================================================
# FUNCIÓN: MOSTRAR ESTADÍSTICAS (Original con todas las opciones)
# ============================================================================

