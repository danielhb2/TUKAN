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
# TUKAN - Módulo de Notas (Crear y Abrir)
# ============================================================================

new_note() {
    local dirs
    dirs=$(find "$TUKAN_DIR" -mindepth 1 -type d | sed "s|$TUKAN_DIR/||" | sort)
    
    local selected_dir
    selected_dir=$(echo -e "[Base]\n$dirs" | 
        fzf "${FZF_OPTS[@]}" \
            --prompt="$(render_icon '📕') Directorio para nueva nota > " \
            --preview="
                [[ '{}' == '[Base]' ]] && DIR='$TUKAN_DIR' || DIR='$TUKAN_DIR/{}'
                echo -e \"\e[1mDirectorio:\e[0m \$DIR\"
                echo
                COUNT=\$(find \"\$DIR\" -maxdepth 1 -type f -name '*.$TEXT_FORMAT' 2>/dev/null | wc -l)
                echo -e \"\e[2mNotas actuales: \$COUNT\e[0m\"
            ")
    
    [[ -z "$selected_dir" ]] && return
    
    local datetime
    datetime=$(get_current_date_time)
    local notepath
    
    if [[ "$selected_dir" == "." ]]; then
        notepath="$TUKAN_DIR/$datetime.$TEXT_FORMAT"
    else
        notepath="$TUKAN_DIR/$selected_dir/$datetime.$TEXT_FORMAT"
    fi
    
    # Crear nota con plantilla
    cat > "$notepath" << EOF
# Título de la nota
#etiqueta1 #etiqueta2

Contenido de la nota...
EOF
    
    ${EDITOR} "$notepath"
}

# ============================================================================
# FUNCIÓN: ABRIR NOTA EXISTENTE
# ============================================================================

open_note() {
    while true; do
        local note_data
        note_data=$(list_all_notes | while read -r note; do
            echo "$(basename "$note")|$(get_title "$TUKAN_DIR/$note" | sed "s/://g")|$note"
        done | 
            fzf "${FZF_OPTS[@]}" \
                "${FZF_PREVIEW_OPTS[@]}" \
                $(list_order) \
                --delimiter='|' \
                --with-nth=1 \
                --prompt="$(render_icon '📖') Abrir > " \
                --preview='
                    IFS="|" read -r BASENAME TITLE FULLNOTE <<< {}
                    FILENAME="$BASENAME"
                    RELDIR=$(get_relative_dir "'$TUKAN_DIR'/$FULLNOTE")
                    CREATEDATE=$(get_creation_date "'$TUKAN_DIR'/$FULLNOTE")
                    FILESIZE=$(get_file_size "'$TUKAN_DIR'/$FULLNOTE")
                    MODDATE=$(get_mod_date "'$TUKAN_DIR'/$FULLNOTE")
                    
# Extraer hashtags
HASHTAGS=$(sed -n "2p" "'$TUKAN_DIR'/$FULLNOTE" | grep -o "#[[:alnum:]_-]\+" | tr "\n" " " | sed "s/[[:space:]]*$//")
if [[ -z "$HASHTAGS" ]]; then
    HASHTAGS_DISPLAY="\e[2mSin etiquetas\e[0m"
else
    HASHTAGS_DISPLAY="\e[1;35m$HASHTAGS\e[0m"
fi

echo -e "\e[1;36m┌──────────────────────── METADATA ────────────────────────┐\e[0m"
echo -e "\e[1;36m│\e[0m \e[1m$FILENAME\e[0m"
echo -e "\e[1;36m│\e[0m \e[2m$RELDIR\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mCreación: $CREATEDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mModificación: $MODDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
echo -e "\e[1;36m│\e[0m Etiquetas: $HASHTAGS_DISPLAY"
echo -e "\e[1;36m└──────────────────────────────────────────────────────────┘\e[0m"
echo
echo -e "\e[1;35m═══ Título ═══\e[0m"
echo -e "\e[1m$TITLE\e[0m" | view_content
echo
echo -e "\e[1;35m═══ Contenido ═══\e[0m"
sed "1{/^#!/ { n; n; d; }; d; }; /^#[[:alnum:]_-]/{/^#[^!]/d}" "'$TUKAN_DIR'/$FULLNOTE" | view_content
                ')
        
        [[ -z "$note_data" ]] && break
        
        IFS="|" read -r basename title fullnote <<< "$note_data"
        note_actions_menu "$TUKAN_DIR/$fullnote"
    done
}