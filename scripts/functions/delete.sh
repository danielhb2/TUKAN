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
# TUKAN - Módulo de Eliminar Notas
# ============================================================================

delete_notes() {
    local notes_data
    notes_data=$(list_all_notes | while read -r note; do
        echo "$(basename "$note")|$(get_title "$TUKAN_DIR/$note" | sed "s/://g")|$note"
    done | 
        fzf "${FZF_OPTS[@]}" \
            "${FZF_PREVIEW_OPTS[@]}" \
            $(list_order) \
            --multi \
            --delimiter='|' \
            --with-nth=1 \
            --prompt="$(render_icon '🔥') Seleccionar notas a borrar (Tab para múltiple) > " \
            --preview='
                echo -e "\e[97;41m$(repeat_char "=" 90)\e[0m"
                echo -e "\e[97;41m            ATENCIÓN: NO SE PUEDE DESHACER - CONFIRME CON SI O S EN MAYÚSCULAS            \e[0m"
                echo -e "\e[97;41m$(repeat_char "=" 90)\e[0m"
                
                IFS="|" read -r BASENAME TITLE FULLNOTE <<< {}
                FILENAME="$BASENAME"
                RELDIR=$(get_relative_dir "'$TUKAN_DIR'/$FULLNOTE")
                CREATEDATE=$(get_creation_date "'$TUKAN_DIR'/$FULLNOTE")
                MODDATE=$(get_mod_date "'$TUKAN_DIR'/$FULLNOTE")
                FILESIZE=$(get_file_size "'$TUKAN_DIR'/$FULLNOTE")
                
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
    
    [[ -z "$notes_data" ]] && return
    
    # Recopilar notas seleccionadas
    local -a notes=()
    while IFS="|" read -r basename title fullnote; do
        notes+=("$fullnote")
    done <<< "$notes_data"
    
    # Confirmación
    local confirmation
    confirmation=$(printf "%s\n" "${notes[@]}" | 
        while read -r note; do
            echo "$(basename "$note")|$(get_title "$TUKAN_DIR/$note" | sed "s/://g")|$note"
        done | 
        fzf --print-query \
            "${FZF_OPTS[@]}" \
            --disabled \
            --delimiter='|' \
            --with-nth=1 \
            --prompt="Escriba 'SI' o 'S' (en mayúsculas) para confirmar > " \
            --preview='
                echo -e "\e[97;41m ⚠  CONFIRMACIÓN DE BORRADO CON '\''S'\'' o '\''SI'\'' en MAYÚSCULAS ⚠  \e[0m"
                echo -e "\e[97;41m ⚠                NO SE PUEDE DESHACER               ⚠  \e[0m"
                echo
                echo "Notas a eliminar:"
                echo
            ' | head -n1)
    
    if [[ "$confirmation" =~ ^[S][I]?$ ]]; then
        for note in "${notes[@]}"; do
            rm "$TUKAN_DIR/$note"
        done
        echo "Notas eliminadas: ${#notes[@]}"
    else
        echo "Operación cancelada"
    fi
}
