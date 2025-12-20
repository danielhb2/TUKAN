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
# TUKAN - Módulo de Etiquetas
# ============================================================================

open_tags() {
    while true; do
        # Seleccionar etiqueta
        local tag
        tag=$(list_all_notes | while read -r note; do
            get_tags "$TUKAN_DIR/$note" | grep -oE '#[A-Za-z0-9_]+'
        done | sort | uniq -c | awk '{printf "%s (%d notas)\n", $2, $1}' | sort |
            fzf "${FZF_OPTS[@]}" \
                "${FZF_PREVIEW_OPTS[@]}" \
                --prompt="$(render_icon '🏷') Seleccionar etiqueta > " \
                --preview='
                    TAG=$(echo {} | awk "{print \$1}")
                    echo -e "\e[1;36m════════════════════════════════════════════════════════════\e[0m"
                    echo -e "\e[1;36m  📋 Notas con etiqueta: \e[1;35m$TAG\e[1;36m                        \e[0m"
                    echo -e "\e[1;36m════════════════════════════════════════════════════════════\e[0m"
                    echo
                    find "'$TUKAN_DIR'" -type f -name "*.'"$TEXT_FORMAT"'" 2>/dev/null | while read -r filepath; do
                        if grep -q "$TAG" <(sed -n "2p" "$filepath" 2>/dev/null); then
                            TITLE=$(sed -n "1p" "$filepath" | sed "s/^# //" | sed "s/://g" | head -c 60)
                            FILENAME=$(basename "$filepath")
                            echo -e "  \e[33m•\e[0m \e[1m$TITLE\e[0m"
                            echo -e "    \e[2m$FILENAME\e[0m"
                            echo
                        fi
                    done
                ' | 
            awk '{print $1}')
        
        [[ -z "$tag" ]] && break
        
        # Mostrar notas con esa etiqueta
        local note_data
        note_data=$(list_all_notes | while read -r note; do
            get_tags "$TUKAN_DIR/$note" | grep -q "$tag" && echo "$note"
        done | while read -r note; do
            echo "$(get_title "$TUKAN_DIR/$note" | sed "s/://g"):$note"
        done | 
            fzf "${FZF_OPTS[@]}" \
                "${FZF_PREVIEW_OPTS[@]}" \
                $(list_order) \
                --prompt="$(render_icon '📖') Notas con $tag > " \
                --preview='
                    IFS=":" read -r TITLE NOTE <<< {}
                    FILENAME=$(basename "$NOTE")
                    RELDIR=$(get_relative_dir "$NOTE")
                    CREATEDATE=$(get_creation_date "'$TUKAN_DIR'/$NOTE")
                    MODDATE=$(get_mod_date "'$TUKAN_DIR'/$NOTE")
                    FILESIZE=$(get_file_size "'$TUKAN_DIR'/$NOTE")
                    
                    # Extraer hashtags
                    HASHTAGS=$(sed -n "2p" "'$TUKAN_DIR'/$NOTE" | grep -o "#[[:alnum:]_-]\+" | tr "\n" " " | sed "s/[[:space:]]*$//")
                    if [[ -z "$HASHTAGS" ]]; then
                        HASHTAGS_DISPLAY="\e[2mSin etiquetas\e[0m"
                    else
                        HASHTAGS_DISPLAY="\e[1;35m$HASHTAGS\e[0m"
                    fi

                    echo -e "\e[1;36m┌──────────────────────── METADATA ───────────────────────┐\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[1m$FILENAME\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2m$RELDIR\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2mCreación: $CREATEDATE\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2mModificación: $MODDATE\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
                    echo -e "\e[1;36m│\e[0m Etiquetas: $HASHTAGS_DISPLAY"
                    echo -e "\e[1;36m└─────────────────────────────────────────────────────────┘\e[0m"
                    echo
                    echo -e "\e[1;35m═══ Título ═══\e[0m"
                    echo -e "\e[1m$TITLE\e[0m" | view_content
                    echo
                    echo -e "\e[1;35m═══ Contenido ═══\e[0m"
                    sed "1{/^#!/ { n; n; d; }; d; }; /^#[[:alnum:]_-]/{/^#[^!]/d}" "'$TUKAN_DIR'/$NOTE" | view_content
                ')
        
        if [[ -n "$note_data" ]]; then
            IFS=":" read -r title note <<< "$note_data"
            note_actions_menu "$TUKAN_DIR/$note"
        fi
    done
}