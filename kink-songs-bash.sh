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

# Default values
NUM_SONGS=25
SHOW_COLORS=true
SHOW_HEADER=true
SHOW_FOOTER=true
QUIET=false
CONTINUOUS=false
REFRESH_INTERVAL=30

usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Options:
    -n, --number NUM      Number of songs to display (default: 25)
    -c, --no-colors       Disable colored output
    --no-header           Disable header display
    --no-footer           Disable footer display
    -q, --quiet           Minimal output (header/footer/colors disabled)
    --continuous          Enable continuous mode with periodic refresh
    --interval SEC        Refresh interval in seconds (default: 30, requires --continuous)
    -h, --help            Show this help message

Examples:
    $0                    # Display 25 songs with colors
    $0 -n 10              # Display 10 songs
    $0 --no-colors        # Display 25 songs without colors
    $0 --continuous       # Refresh every 30 seconds
    $0 --continuous --interval 60  # Refresh every 60 seconds
EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -n|--number)
                NUM_SONGS="$2"
                if ! [[ "$NUM_SONGS" =~ ^[0-9]+$ ]]; then
                    echo -e "${RED}Error: Number must be a positive integer${NC}" >&2
                    exit 1
                fi
                shift 2
                ;;
            -c|--no-colors)
                SHOW_COLORS=false
                shift
                ;;
            --no-header)
                SHOW_HEADER=false
                shift
                ;;
            --no-footer)
                SHOW_FOOTER=false
                shift
                ;;
            -q|--quiet)
                QUIET=true
                SHOW_COLORS=false
                SHOW_HEADER=false
                SHOW_FOOTER=false
                shift
                ;;
            --continuous)
                CONTINUOUS=true
                shift
                ;;
            --interval)
                REFRESH_INTERVAL="$2"
                if ! [[ "$REFRESH_INTERVAL" =~ ^[0-9]+$ ]]; then
                    echo -e "${RED}Error: Interval must be a positive integer${NC}" >&2
                    exit 1
                fi
                shift 2
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo -e "${RED}Error: Unknown option '$1'${NC}" >&2
                usage >&2
                exit 1
                ;;
        esac
    done
}

print_header() {
    if [ "$SHOW_COLORS" = true ]; then
        echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
        echo -e "${MAGENTA}║${NC}   ${CYAN}KINK FM - Recently Played Songs${NC}      ${MAGENTA}║${NC}"
        echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    else
        echo "╔════════════════════════════════════════╗"
        echo "║   KINK FM - Recently Played Songs      ║"
        echo "╚════════════════════════════════════════╝"
    fi
    echo ""
}

print_footer() {
    if [ "$SHOW_COLORS" = true ]; then
        echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
        echo -e "${MAGENTA}║${NC} ${BLUE}Data source: KINK FM${NC}${MAGENTA}                   ║${NC}"
        echo -e "${MAGENTA}║${NC} ${BLUE}https://kink.nl/gedraaid/kink${NC}${MAGENTA}          ║${NC}"
        echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
    else
        echo "╔════════════════════════════════════════╗"
        echo "║ Data source: KINK FM                   ║"
        echo "║ https://kink.nl/gedraaid/kink          ║"
        echo "╚════════════════════════════════════════╝"
    fi
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
    if [ "$SHOW_COLORS" = false ]; then
        echo ""
        return
    fi
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
    
    if [ "$SHOW_COLORS" = true ]; then
        printf "${color}%2d. %s${NC}\n" "$track_num" "$artist"
        printf "    ${color}'%s'${NC}\n\n" "$title"
    else
        printf "%2d. %s\n" "$track_num" "$artist"
        printf "    '%s'\n\n" "$title"
    fi
}

display_tracks() {
    local tracks="$1"
    local count=$(echo "$tracks" | wc -l)
    
    if [ "$QUIET" = false ]; then
        echo -e "${GREEN}Found ${count} recently played songs:${NC}\n"
    fi
    
    local i=1
    while IFS= read -r track && [ $i -le "$NUM_SONGS" ]; do
        local title=$(extract_field "$track" "title")
        local artist=$(extract_field "$track" "artist")
        
        title=$(unescape_text "$title")
        artist=$(unescape_text "$artist")
        
        local color=$(get_color $((i - 1)))
        display_track "$i" "$artist" "$title" "$color"
        
        ((i++))
    done <<< "$tracks"
}

run_once() {
    if [ "$SHOW_HEADER" = true ]; then
        print_header
    fi
    
    local html=$(fetch_tracks_html)
    if [ -z "$html" ]; then
        echo -e "${RED}Error: Could not fetch data from KINK FM${NC}" >&2
        return 1
    fi
    
    local tracks=$(extract_tracks "$html")
    if [ -z "$tracks" ]; then
        echo -e "${RED}Error: Could not parse track data${NC}" >&2
        return 1
    fi
    
    display_tracks "$tracks"
    
    if [ "$SHOW_FOOTER" = true ]; then
        print_footer
    fi
}

main() {
    parse_arguments "$@"
    
    if [ "$CONTINUOUS" = true ]; then
        while true; do
            run_once
            if [ $? -eq 0 ]; then
                sleep "$REFRESH_INTERVAL"
                clear
            else
                exit 1
            fi
        done
    else
        run_once
        if [ $? -ne 0 ]; then
            exit 1
        fi
    fi
}

main "$@"
