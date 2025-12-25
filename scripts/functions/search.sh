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
# TUKAN - Módulo de Búsqueda
# ============================================================================

search_notes() {
    local last_query=""
    
    while true; do
        local selected
        selected=$(
            echo "Ingrese su búsqueda para comenzar..." | 
            fzf --print-query \
                --query="$last_query" \
                "${FZF_OPTS[@]}" \
                --bind "ctrl-x:preview-page-up,ctrl-z:preview-page-down" \
                --bind "ctrl-a:preview-up,ctrl-s:preview-down" \
                --header-lines=1 \
                --prompt="$(render_icon '🔎') Buscar > " \
                --disabled \
                --preview-window="down:$PREVIEW_SIZE:noinfo:wrap:+{2}" \
                --preview-label=' [ ctrl-x, ctrl-z, ctrl-a, ctrl-s ] Búsqueda en tiempo real ' \
                --bind 'change:reload(QUERY={q}; if [[ -z "$QUERY" ]] || [[ ${#QUERY} -lt 2 ]]; then echo "Escriba al menos 2 caracteres para buscar..."; exit 0; fi; FILES_BY_NAME=$(find '"$TUKAN_DIR"' -type f -name "*$QUERY*.'"$TEXT_FORMAT"'" 2>/dev/null | sed "s|'"$TUKAN_DIR/"'||"); FILES_BY_CONTENT=$(find '"$TUKAN_DIR"' -type f -name "*.'"$TEXT_FORMAT"'" 2>/dev/null | xargs grep -Hni "$QUERY" 2>/dev/null | sed "s|'"$TUKAN_DIR/"'||"); RESULTS=$(echo -e "$FILES_BY_NAME\n$FILES_BY_CONTENT" | grep -v "^$"); if [[ -n "$RESULTS" ]]; then COUNT=$(echo "$RESULTS" | wc -l); echo "✓ Encontrados $COUNT resultados para: $QUERY"; echo "$RESULTS" | while read -r LINE_DATA; do if [[ "$LINE_DATA" != *":"* ]]; then printf "%-8s ║ %-50s ║ %s\n" "ARCHIVO" "Coincidencia en nombre" "$LINE_DATA"; else NOTE=$(echo "$LINE_DATA" | cut -d: -f1); LINE_NUM=$(echo "$LINE_DATA" | cut -d: -f2); CONTENT=$(echo "$LINE_DATA" | cut -d: -f3-); CLEANED=$(echo "$CONTENT" | sed "s/^[[:space:]]*//" | cut -c1-100); printf "%-8s ║ %-50s ║ %s\n" "L$LINE_NUM" "$CLEANED..." "$NOTE"; fi; done | sort -u; else echo "✗ No se encontraron resultados para: $QUERY"; fi)' \
                --preview='
                    # Extraer información de la línea seleccionada
                    LINE_INFO={}
                    QUERY={q}
                    
                    # Si no hay query o es muy corta, mostrar ayuda
                    if [[ -z "$QUERY" ]] || [[ ${#QUERY} -lt 2 ]]; then
                        echo -e "\e[1;36m╔════════════════════════════════════════════════════════════╗\e[0m"
                        echo -e "\e[1;36m║          🔎 BÚSQUEDA INTERACTIVA EN TIEMPO REAL            ║\e[0m"
                        echo -e "\e[1;36m╚════════════════════════════════════════════════════════════╝\e[0m"
                        echo
                        echo -e "\e[1;33m💡 Cómo usar:\e[0m"
                        echo -e "   • Escribe para buscar en todas tus notas"
                        echo -e "   • Los resultados aparecen mientras escribes"
                        echo -e "   • No necesitas presionar Enter"
                        echo -e "   • Mínimo 2 caracteres para buscar"
                        echo
                        echo -e "\e[1;33m⌨  Controles:\e[0m"
                        echo -e "   • \e[32m↑↓\e[0m         Navegar resultados"
                        echo -e "   • \e[32mEnter\e[0m      Abrir nota seleccionada"
                        echo -e "   • \e[32mEsc\e[0m        Volver al menú"
                        echo -e "   • \e[32mCtrl+X/Z\e[0m   Scroll página preview"
                        echo -e "   • \e[32mCtrl+A/S\e[0m   Scroll línea preview"
                        echo
                        echo -e "\e[2m   La búsqueda es en TODO el directorio TUKAN,"
                        echo -e "   incluyendo base y todos los subdirectorios.\e[0m"
                        exit 0
                    fi
                    
                    # Verificar si hay un resultado seleccionado válido
                    if [[ "$LINE_INFO" =~ ^(✓|✗) ]] || [[ "$LINE_INFO" =~ ^Escriba ]]; then
                        echo -e "\e[2mSelecciona un resultado para ver el preview...\e[0m"
                        exit 0
                    fi
                    
                    # Parsear la información (formato: "L123 ║ contenido... ║ archivo.md")
                    LINE_NUM=$(echo "$LINE_INFO" | awk -F"║" "{print \$1}" | sed "s/L//" | tr -d " ")
                    NOTE=$(echo "$LINE_INFO" | awk -F"║" "{print \$3}" | sed "s/^[[:space:]]*//" | sed "s/[[:space:]]*$//")
                    
                    # Verificar que tenemos un archivo válido
                    if [[ -z "$NOTE" ]] || [[ ! -f "'$TUKAN_DIR'/$NOTE" ]]; then
                        exit 0
                    fi
                    
                    # Obtener información del archivo
                    FILE="'$TUKAN_DIR'/$NOTE"
                    FILENAME=$(basename "$NOTE")
                    RELDIR=$(get_relative_dir "$NOTE")
                    CREATEDATE=$(get_creation_date "$FILE")
                    MODDATE=$(get_mod_date "$FILE")
                    TITLE=$(get_title "$FILE" | sed "s/://g")
                    FILESIZE=$(get_file_size "'$TUKAN_DIR'/$NOTE")
                    # Extraer hashtags de la segunda línea
                    HASHTAGS=$(sed -n "2p" "$FILE" | grep -o "#[[:alnum:]_-]\+" | tr "\n" " " | sed "s/[[:space:]]*$//")
                    
                    # Formatear display de hashtags
                    if [[ -z "$HASHTAGS" ]]; then
                        HASHTAGS_DISPLAY="\e[2mSin etiquetas\e[0m"
                    else
                        HASHTAGS_DISPLAY="\e[1;35m$HASHTAGS\e[0m"
                    fi
                    
                    # Calcular líneas para el contexto
                    MAX_LINES=$(wc -l < "$FILE")
                    START_LINE=$((LINE_NUM > '$START_LINE_SEARCH_PREVIEW' ? LINE_NUM - '$START_LINE_SEARCH_PREVIEW' : 1))
                    END_LINE=$((LINE_NUM + '$END_LINE_SEARCH_PREVIEW' < MAX_LINES ? LINE_NUM + '$END_LINE_SEARCH_PREVIEW' : MAX_LINES))
                    
                    # Ajustar línea si hay shebang
                    TITLE_LINE=$(if head -n 1 "$FILE" | grep -q "^#!"; then echo 2; else echo 1; fi)
                    CONTENT_START=$((TITLE_LINE + 1))
                    
                    # Ajustar números de línea si hay shebang
                    if [[ $TITLE_LINE -eq 2 ]]; then
                        START_LINE=$((START_LINE > 0 ? START_LINE + 1 : 1))
                        END_LINE=$((END_LINE + 1))
                        LINE_NUM=$((LINE_NUM + 1))
                    fi
                    
                    # Mostrar información del archivo con hashtags
                    echo -e "\e[1;36m┌──────────────────────── METADATA ───────────────────────┐\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[1m$FILENAME\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2m$RELDIR\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2mCreación: $CREATEDATE\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2mModificación: $MODDATE\e[0m"
                    echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
                    echo -e "\e[1;36m│\e[0m Etiquetas: $HASHTAGS_DISPLAY"
                    echo -e "\e[1;36m│\e[0m \e[1;33m🎯 Coincidencia en línea: $LINE_NUM\e[0m"
                    echo -e "\e[1;36m└─────────────────────────────────────────────────────────┘\e[0m"
                    echo
                    
                    # Mostrar título
                    echo -e "\e[1;35m═══ Título ═══\e[0m"
                    echo -e "\e[1m$TITLE\e[0m" | view_content
                    echo
                    
                    # Mostrar contenido con resaltado
                    echo -e "\e[1;35m═══ Contenido (líneas $START_LINE-$END_LINE) ═══\e[0m"
                    
                    # Extraer y resaltar el contenido
                    sed "1{/^#!/ { n; n; d; }; d; }; /^#[[:alnum:]_-]/{/^#[^!]/d}" "$FILE" | 
                        awk -v start=$START_LINE -v end=$END_LINE -v highlight=$LINE_NUM -v query="$QUERY" "
                            NR >= start && NR <= end {
                                line_num = NR
                                if (line_num == highlight) {
                                    # Línea con coincidencia - resaltar
                                    gsub(query, \"\033[30;47m&\033[0m\", \$0)
                                    print \"\033[1;33m▶\033[0m \033[33m\" line_num \":\033[0m \" \$0
                                } else {
                                    print \"\033[2m  \" line_num \":\033[0m \" \$0
                                }
                            }
                        " | view_content
                ')
        
        [[ -z "$selected" ]] && break
        
        # Obtener query y resultado seleccionado
        last_query=$(echo "$selected" | head -n1)
        local result_line
        result_line=$(echo "$selected" | tail -n1)
        
        # Verificar que tenemos un resultado válido
        if [[ "$result_line" =~ ^(✓|✗) ]] || [[ "$result_line" =~ ^Escriba ]]; then
            continue
        fi
        
        # Parsear el resultado
        local line_num
        local note
        line_num=$(echo "$result_line" | awk -F"║" '{print $1}' | sed 's/L//' | tr -d ' ')
        note=$(echo "$result_line" | awk -F"║" '{print $3}' | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
        
        # Abrir menú de acciones si tenemos una nota válida
        if [[ -n "$note" && -f "$TUKAN_DIR/$note" ]]; then
            note_actions_menu "$TUKAN_DIR/$note" "$line_num"
        fi
    done
}
