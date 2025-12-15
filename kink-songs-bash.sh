#!/bin/bash

# KINK FM Songs Display Script (Pure Bash)
# Fetches and displays recently played songs from KINK FM
# No external dependencies except curl and standard Unix tools

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

print_header() {
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}   ${CYAN}KINK FM - Recently Played Songs${NC}      ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    echo ""
}

print_footer() {
    echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC} ${BLUE}Data source: KINK FM${NC}${MAGENTA}                   ║${NC}"
    echo -e "${MAGENTA}║${NC} ${BLUE}https://kink.nl/gedraaid/kink${NC}${MAGENTA}          ║${NC}"
    echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
}

fetch_tracks_html() {
    curl -s "https://kink.nl/gedraaid/kink" 2>/dev/null
}

extract_tracks() {
    local html="$1"
    echo "$html" | sed 's/\\"/"/g' | grep -o '"title":"[^"]*","artist":"[^"]*"' || true
}

unescape_text() {
    local text="$1"
    echo "$text" | sed 's/\\u0026/\&/g'
}

extract_field() {
    local track="$1"
    local field="$2"
    echo "$track" | sed "s/.*\"$field\":\"\([^\"]*\)\".*/\1/"
}

get_color() {
    local idx=$1
    case $((idx % 3)) in
        0) echo "$CYAN" ;;
        1) echo "$YELLOW" ;;
        2) echo "$MAGENTA" ;;
    esac
}

display_track() {
    local track_num=$1
    local artist=$2
    local title=$3
    local color=$4
    
    printf "${color}%2d. %s${NC}\n" "$track_num" "$artist"
    printf "    ${color}'%s'${NC}\n\n" "$title"
}

display_tracks() {
    local tracks="$1"
    local count=$(echo "$tracks" | wc -l)
    
    echo -e "${GREEN}Found ${count} recently played songs:${NC}\n"
    
    local i=1
    while IFS= read -r track && [ $i -le 25 ]; do
        local title=$(extract_field "$track" "title")
        local artist=$(extract_field "$track" "artist")
        
        title=$(unescape_text "$title")
        artist=$(unescape_text "$artist")
        
        local color=$(get_color $((i - 1)))
        display_track "$i" "$artist" "$title" "$color"
        
        ((i++))
    done <<< "$tracks"
}

main() {
    print_header
    
    local html=$(fetch_tracks_html)
    if [ -z "$html" ]; then
        echo -e "${RED}Error: Could not fetch data from KINK FM${NC}"
        exit 1
    fi
    
    local tracks=$(extract_tracks "$html")
    if [ -z "$tracks" ]; then
        echo -e "${RED}Error: Could not parse track data${NC}"
        exit 1
    fi
    
    display_tracks "$tracks"
    
    print_footer
}

main
