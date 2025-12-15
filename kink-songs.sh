#!/bin/bash

# KINK FM Songs Display Script
# Fetches and displays recently played songs from KINK FM

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC}   ${CYAN}KINK FM - Recently Played Songs${NC}      ${MAGENTA}║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
echo ""

# Use Python to parse the JSON from the page
python3 << 'PYTHON_SCRIPT'
import json
import re
import urllib.request
import sys

try:
    # Fetch the page
    response = urllib.request.urlopen("https://kink.nl/gedraaid/kink", timeout=15)
    html = response.read().decode('utf-8')
    
    # The JSON is escaped with backslashes in HTML: \"playedTracks\":
    # Pattern: playedTracks\":[{...}],\"totalTrackCount
    match = re.search(r'playedTracks\\":\s*\[(.*?)\],\\"totalTrackCount', html, re.DOTALL)
    
    if match:
        tracks_str = match.group(1)
        # Unescape the JSON string - replace \" with "
        tracks_str = tracks_str.replace('\\"', '"').replace('\\/', '/')
        
        # Now find individual tracks
        track_pattern = r'"title":"([^"]+)","artist":"([^"]+)"'
        matches = re.findall(track_pattern, tracks_str)
        
        if matches:
            print(f"\033[1;32mFound {len(matches)} recently played songs:\033[0m\n")
            for i, (title, artist) in enumerate(matches[:25], 1):
                # Decode unicode escapes in artist and title
                artist = artist.encode('utf-8').decode('unicode-escape')
                title = title.encode('utf-8').decode('unicode-escape')
                color = ['\033[0;36m', '\033[0;33m', '\033[0;35m'][i % 3]
                reset = '\033[0m'
                print(f"{color}{i:2d}. {artist}{reset}")
                print(f"    {color}'{title}'{reset}")
                print()
        else:
            print("Could not parse track data")
            sys.exit(1)
    else:
        print("Could not extract playedTracks from the page")
        sys.exit(1)
        
except urllib.error.URLError as e:
    print(f"Network Error: {e}")
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

PYTHON_SCRIPT

echo -e "${MAGENTA}╔════════════════════════════════════════╗${NC}"
echo -e "${MAGENTA}║${NC} ${BLUE}Data source: KINK FM${NC}${MAGENTA}                   ║${NC}"
echo -e "${MAGENTA}║${NC} ${BLUE}https://kink.nl/gedraaid/kink${NC}${MAGENTA}          ║${NC}"
echo -e "${MAGENTA}╚════════════════════════════════════════╝${NC}"
