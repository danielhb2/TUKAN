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
# TUKAN - Módulo de Acciones de Notas
# ============================================================================

note_actions_menu() {
    local note="$1"
    local line="${2:-1}"
    
    local actions=("Editar" "Mover a otro directorio" "Borrar" "Cancelar")
    
    local selected
    selected=$(printf "%s\n" "${actions[@]}" | 
        fzf "${FZF_OPTS[@]}" \
            "${FZF_PREVIEW_OPTS[@]}" \
            --prompt="Acciones > " \
            --preview="
                ACTION={}
                FILENAME=\$(basename '$note')
                RELDIR=\$(get_relative_dir '$note')
                CREATEDATE=\$(get_creation_date '$note')
                MODDATE=\$(get_mod_date '$note')
                TITLE=\$(get_title '$note' | sed 's/://g')
                FILESIZE=$(get_file_size "'$TUKAN_DIR'/$NOTE")
                # Extraer hashtags
                HASHTAGS=\$(sed -n \"2p\" '$note' | grep -o \"#[[:alnum:]_-]\+\" | tr \"\n\" \" \" | sed \"s/[[:space:]]*\$//\")
                if [[ -z \"\$HASHTAGS\" ]]; then
                    HASHTAGS_DISPLAY=\"\e[2mSin etiquetas\e[0m\"
                else
                    HASHTAGS_DISPLAY=\"\e[1;35m\$HASHTAGS\e[0m\"
                fi

                echo -e \"\e[1;36m┌────────────────────────── METADATA ─────────────────────────┐\e[0m\"
                echo -e \"\e[1;36m│\e[0m \e[1m\$FILENAME\e[0m\"
                echo -e \"\e[1;36m│\e[0m \e[2m\$RELDIR\e[0m\"
                echo -e \"\e[1;36m│\e[0m \e[2mCreación: \$CREATEDATE\e[0m\"
                echo -e \"\e[1;36m│\e[0m \e[2mModificación: \$MODDATE\e[0m\"
                echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
                echo -e \"\e[1;36m│\e[0m Etiquetas: \$HASHTAGS_DISPLAY\"
                echo -e \"\e[1;36m└─────────────────────────────────────────────────────────────┘\e[0m\"
                echo
                echo -e \"\e[1;33m▶ Acción: \$ACTION\e[0m\"
                echo
                echo -e \"\e[1;35m═══ Título ═══\e[0m\"
                echo -e \"\e[1m\$TITLE\e[0m\" | $VISOR
                echo
                echo -e \"\e[1;35m═══ Contenido ═══\e[0m\"
                sed '1{/^#!/ { n; n; d; }; d; }; /^#[[:alnum:]_-]/{/^#[^!]/d}' '$note' | $VISOR
            ")
    
    case "$selected" in
        "Editar")
            ${EDITOR} "$note"
            ;;
        "Mover a otro directorio")
            move_note "$note"
            ;;
        "Borrar")
            local confirm
            confirm=$(echo -e "NO\nSI" | 
                fzf "${FZF_OPTS[@]}" \
                    --prompt="¿Confirmar borrado? > " \
                    --preview="echo -e '\e[97;41mATENCIÓN: Esta acción no se puede deshacer\e[0m'")
            
            [[ "$confirm" == "SI" ]] && rm "$note" && echo "Nota eliminada"
            ;;
    esac
}