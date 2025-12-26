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
# TUKAN - Módulo de Estadísticas
# ============================================================================

show_statistics() {
    while true; do
        local stat_options=(
            "⏱️ Ver todas por modificación (más nuevas primero)"
            "⏱️ Ver todas por modificación (más viejas primero)"
            "⏱️ Ver todas por creación (más nuevas primero)"
            "⏱️ Ver todas por creación (más viejas primero)"
            "📅 Últimas 24 horas"
            "📆 Últimos 7 días"
            "🗓 Últimos 30 días"
            "📊 Estadísticas generales"
            "Volver"
        )
        
        local selected
        selected=$(printf "%s\n" "${stat_options[@]}" | 
            fzf "${FZF_OPTS[@]}" \
                "${FZF_PREVIEW_OPTS[@]}" \
                --prompt="$(render_icon '📊') Estadísticas > " \
                --preview='
                    for DIR in "1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros" "6-Notas_varias"; do
                        DIR_PATH="'$TUKAN_DIR'/$DIR"
                        if [[ -d "$DIR_PATH" ]]; then
                            NOTE_COUNT=$(find "$DIR_PATH" -maxdepth 1 -type f -name "*.'$TEXT_FORMAT'" 2>/dev/null | wc -l)
                            DISPLAY_NAME=$(echo "$DIR" | sed "s/^[0-9]-//" | tr "_" " ")
                            
                            echo -e "\e[1;36m▌ $DISPLAY_NAME\e[0m \e[2m($NOTE_COUNT notas)\e[0m"
                            echo -e "\e[2m────────────────────────────────────\e[0m"
                            
                            if [ $NOTE_COUNT -gt 0 ]; then
                                find "$DIR_PATH" -maxdepth 1 -type f -name "*.'$TEXT_FORMAT'" 2>/dev/null | sort -r | head -n 3 | while read -r NOTE; do
                                    TITLE=$(get_title "$NOTE" | sed "s/://g" | head -c 40)
                                    echo -e "  • \e[33m$TITLE\e[0m"
                                done
                                if [ $NOTE_COUNT -gt 3 ]; then
                                    echo -e "  \e[2m  ... y $((NOTE_COUNT - 3)) más\e[0m"
                                fi
                            else
                                echo -e "  \e[2m(vacío)\e[0m"
                            fi
                            echo
                        fi
                    done
                ')
        
        [[ -z "$selected" || "$selected" == "Volver" ]] && break
        
        case "$selected" in
            "⏱️ Ver todas por modificación (más nuevas primero)")
                view_notes_by_date "newest" "mod"
                ;;
            "⏱️ Ver todas por modificación (más viejas primero)")
                view_notes_by_date "oldest" "mod"
                ;;
            "⏱️ Ver todas por creación (más nuevas primero)")
                view_notes_by_date "newest" "create"
                ;;
            "⏱️ Ver todas por creación (más viejas primero)")
                view_notes_by_date "oldest" "create"
                ;;
            "📅 Últimas 24 horas")
                view_notes_by_timeframe "1"
                ;;
            "📆 Últimos 7 días")
                view_notes_by_timeframe "7"
                ;;
            "🗓 Últimos 30 días")
                view_notes_by_timeframe "30"
                ;;
            "📊 Estadísticas generales")
                show_general_stats
                ;;
        esac
    done
}

# Ver notas ordenadas por fecha
view_notes_by_date() {
    local sort_order="$1"
    local date_type="${2:-mod}"  # "mod" o "create"
    
    # Limpiar archivos temporales
    local temp_file=$(mktemp)
    local sorted_file=$(mktemp)
    
    # Recolectar TODAS las notas de TODOS los directorios
    for dir in "1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros" "6-Notas_varias"; do
        local dir_path="$TUKAN_DIR/$dir"
        if [[ -d "$dir_path" ]]; then
            while IFS= read -r -d '' note_path; do
                local note
                note=$(echo "$note_path" | sed "s|$TUKAN_DIR/||")
                
                # Elegir timestamp según el tipo
                local time_stamp
                if [[ "$date_type" == "create" ]]; then
                    # Usar birth time (creación)
                    time_stamp=$(stat -c %W "$note_path" 2>/dev/null)
                    # Si birth time no está disponible (0), usar mtime
                    if [[ "$time_stamp" == "0" || -z "$time_stamp" ]]; then
                        time_stamp=$(stat -c %Y "$note_path" 2>/dev/null || stat -f %m "$note_path" 2>/dev/null)
                    fi
                else
                    # Usar modification time
                    time_stamp=$(stat -c %Y "$note_path" 2>/dev/null || stat -f %m "$note_path" 2>/dev/null)
                fi
                
                local basename_only
                basename_only=$(basename "$note")
                local title
                title=$(get_title "$note_path" | sed "s/://g")
                echo "$time_stamp|$basename_only|$title|$note" >> "$temp_file"
            done < <(find "$dir_path" -maxdepth 1 -type f -name "*.$TEXT_FORMAT" -print0 2>/dev/null)
        fi
    done
    
    # Ordenar según criterio
    if [[ "$sort_order" == "newest" ]]; then
        sort -t'|' -k1 -rn "$temp_file" | cut -d'|' -f2- > "$sorted_file"
    else
        sort -t'|' -k1 -n "$temp_file" | cut -d'|' -f2- > "$sorted_file"
    fi
    
    local total_notes
    total_notes=$(wc -l < "$sorted_file" | tr -d ' ')
    local sort_label
    if [[ "$date_type" == "create" ]]; then
        sort_label="creación"
    else
        sort_label="modificación"
    fi
    
    while true; do
        local note_data
        note_data=$(cat "$sorted_file" | 
            fzf "${FZF_OPTS[@]}" \
                "${FZF_PREVIEW_OPTS[@]}" \
                --delimiter='|' \
                --with-nth=1 \
                --border-label="TUKAN - $total_notes notas por $sort_label" \
                --prompt="$(render_icon '⏱') Ver > " \
                --preview='
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

echo -e "\e[1;36m┌──────────────────────── METADATA ──────────────────────┐\e[0m"
echo -e "\e[1;36m│\e[0m \e[1m$FILENAME\e[0m"
echo -e "\e[1;36m│\e[0m \e[2m$RELDIR\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mCreación: $CREATEDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mModificación: $MODDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
echo -e "\e[1;36m│\e[0m Etiquetas: $HASHTAGS_DISPLAY"
echo -e "\e[1;36m└────────────────────────────────────────────────────────┘\e[0m"
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
    
    rm -f "$temp_file" "$sorted_file"
}

# Ver notas por período
view_notes_by_timeframe() {
    local days="$1"
    
    # Calcular fecha de corte
    local cutoff_time
    cutoff_time=$(date -d "$days days ago" +%s 2>/dev/null || date -v-${days}d +%s 2>/dev/null)
    
    local temp_filtered=$(mktemp)
    local filtered_file=$(mktemp)
    
    # Recolectar notas modificadas en el período
    for dir in "1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros" "6-Notas_varias"; do
        local dir_path="$TUKAN_DIR/$dir"
        if [[ -d "$dir_path" ]]; then
            while IFS= read -r -d '' note_path; do
                local mod_time
                mod_time=$(stat -c %Y "$note_path" 2>/dev/null || stat -f %m "$note_path" 2>/dev/null)
                
                if [[ $mod_time -ge $cutoff_time ]]; then
                    local note
                    note=$(echo "$note_path" | sed "s|$TUKAN_DIR/||")
                    local basename_only
                    basename_only=$(basename "$note")
                    local title
                    title=$(get_title "$note_path" | sed "s/://g")
                    echo "$mod_time|$basename_only|$title|$note" >> "$temp_filtered"
                fi
            done < <(find "$dir_path" -maxdepth 1 -type f -name "*.$TEXT_FORMAT" -print0 2>/dev/null)
        fi
    done
    
    # Ordenar por fecha (más reciente primero)
    sort -t'|' -k1 -rn "$temp_filtered" | cut -d'|' -f2- > "$filtered_file"
    
    local note_count
    note_count=$(wc -l < "$filtered_file" | tr -d ' ')
    
    if [[ $note_count -eq 0 ]]; then
        echo "No hay notas en los últimos $days días." | 
            fzf "${FZF_OPTS[@]}" \
                --disabled \
                --border-label="TUKAN - Sin resultados" \
                --prompt="Presione ESC para volver > "
        rm -f "$temp_filtered" "$filtered_file"
        return
    fi
    
    while true; do
        local note_data
        note_data=$(cat "$filtered_file" | 
            fzf "${FZF_OPTS[@]}" \
                "${FZF_PREVIEW_OPTS[@]}" \
                --delimiter='|' \
                --with-nth=1 \
                --border-label="TUKAN - Últimos $days días ($note_count notas)" \
                --prompt="$(render_icon '📅') Ver > " \
                --preview='
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

echo -e "\e[1;36m┌──────────────────────── METADATA ──────────────────────┐\e[0m"
echo -e "\e[1;36m│\e[0m \e[1m$FILENAME\e[0m"
echo -e "\e[1;36m│\e[0m \e[2m$RELDIR\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mCreación: $CREATEDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mModificación: $MODDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
echo -e "\e[1;36m│\e[0m Etiquetas: $HASHTAGS_DISPLAY"
echo -e "\e[1;36m└────────────────────────────────────────────────────────┘\e[0m"
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
    
    rm -f "$temp_filtered" "$filtered_file"
}

# Estadísticas generales
show_general_stats() {
    while true; do
        local selected
        selected=$({
            echo "========== ESTADÍSTICAS GENERALES =========="
            for dir in "1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros" "6-Notas_varias"; do
                local dir_path="$TUKAN_DIR/$dir"
                if [[ -d "$dir_path" ]]; then
                    local display_name
                    display_name=$(echo "$dir" | sed 's/^[0-9]-//' | tr '_' ' ')
                    echo "──────── $display_name ────────"
                    find "$dir_path" -maxdepth 1 -type f -name "*.$TEXT_FORMAT" 2>/dev/null | sort | 
                    while read -r note_path; do
                        local note
                        note=$(echo "$note_path" | sed "s|$TUKAN_DIR/||")
                        local basename_only
                        basename_only=$(basename "$note")
                        local title
                        title=$(get_title "$note_path" | sed "s/://g")
                        echo "  $basename_only|$title|$note"
                    done
                fi
            done
        } | fzf "${FZF_OPTS[@]}" \
            --bind "ctrl-x:preview-page-up,ctrl-z:preview-page-down" \
            --bind "ctrl-a:preview-up,ctrl-s:preview-down" \
            --delimiter='|' \
            --with-nth=1 \
            --border-label="TUKAN - Estadísticas Generales" \
            --preview-window=right:50%:noinfo:wrap \
            --preview-label=' ESTADÍSTICAS / PREVIEW ' \
            --prompt="Seleccione archivo o ESC para volver > " \
            --preview='
                LINE={}
                # Si es la línea de estadísticas o separadores, mostrar estadísticas generales
                if [[ "$LINE" == "=="* ]] || [[ "$LINE" == "──"* ]]; then
                    echo -e "\e[1;36m========================================\e[0m"
                    echo -e "\e[1;33m        ESTADÍSTICAS TUKAN        \e[0m"
                    echo -e "\e[1;36m========================================\e[0m"
                    echo
                    
                    TOTAL=0
                    for DIR in "1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros" "6-Notas_varias"; do
                        DIR_PATH="'$TUKAN_DIR'/$DIR"
                        COUNT=$(find "$DIR_PATH" -maxdepth 1 -type f -name "*.'$TEXT_FORMAT'" 2>/dev/null | wc -l | tr -d " ")
                        DISPLAY_NAME=$(echo "$DIR" | sed "s/^[0-9]-//" | tr "_" " ")
                        TOTAL=$((TOTAL + COUNT))
                        printf "\e[1m%-20s\e[0m: %3d notas\n" "$DISPLAY_NAME" "$COUNT"
                    done
                    
                    echo
                    echo -e "\e[1;36m────────────────────────────────────────\e[0m"
                    printf "\e[1;32m%-20s\e[0m: %3d notas\n" "TOTAL" "$TOTAL"
                    
                    # Contar notas de últimas 24 horas
                    CUTOFF_24H=$(date -d "1 day ago" +%s 2>/dev/null || date -v-1d +%s 2>/dev/null)
                    COUNT_24H=0
                    for DIR in "1-Ideas" "2-En_curso" "3-Terminado" "4-Cancelado" "5-Proyectos_futuros" "6-Notas_varias"; do
                        DIR_PATH="'$TUKAN_DIR'/$DIR"
                        if [[ -d "$DIR_PATH" ]]; then
                            while read -r NOTE; do
                                MOD_TIME=$(stat -c %Y "$NOTE" 2>/dev/null || stat -f %m "$NOTE" 2>/dev/null)
                                if [[ $MOD_TIME -ge $CUTOFF_24H ]]; then
                                    COUNT_24H=$((COUNT_24H + 1))
                                fi
                            done < <(find "$DIR_PATH" -maxdepth 1 -type f -name "*.'$TEXT_FORMAT'" 2>/dev/null)
                        fi
                    done
                    
                    echo
                    echo -e "\e[1;36m────────────────────────────────────────\e[0m"
                    printf "\e[1;33m%-30s\e[0m: %3d\n" "Modificadas últimas 24h" "$COUNT_24H"
                else
                    # Si es un archivo, mostrar su contenido
                    IFS="|" read -r BASENAME TITLE FULLNOTE <<< "$LINE"
                    if [[ -n "$FULLNOTE" ]]; then
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

echo -e "\e[1;36m┌──────────────────────── METADATA ──────────────────────┐\e[0m"
echo -e "\e[1;36m│\e[0m \e[1m$FILENAME\e[0m"
echo -e "\e[1;36m│\e[0m \e[2m$RELDIR\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mCreación: $CREATEDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mModificación: $MODDATE\e[0m"
echo -e "\e[1;36m│\e[0m \e[2mTamaño: $FILESIZE\e[0m"
echo -e "\e[1;36m│\e[0m Etiquetas: $HASHTAGS_DISPLAY"
echo -e "\e[1;36m└────────────────────────────────────────────────────────┘\e[0m"
echo
echo -e "\e[1;35m═══ Título ═══\e[0m"
echo -e "\e[1m$TITLE\e[0m" | view_content
echo
echo -e "\e[1;35m═══ Contenido ═══\e[0m"
sed "1{/^#!/ { n; n; d; }; d; }; /^#[[:alnum:]_-]/{/^#[^!]/d}" "'$TUKAN_DIR'/$FULLNOTE" | view_content

                    fi
                fi
            ')
        
        # Salir si no hay selección
        [[ -z "$selected" ]] && break
        
        # Si es una línea de estadísticas, ignorar
        [[ "$selected" == "=="* ]] || [[ "$selected" == "──"* ]] && continue
        
        # Si es un archivo, llamar al menú de acciones
        IFS="|" read -r basename title fullnote <<< "$selected"
        if [[ -n "$fullnote" ]]; then
            note_actions_menu "$TUKAN_DIR/$fullnote"
        fi
    done
}