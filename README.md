# KINK FM Recently Played Songs  

I built this because I wanted to check what’s spinning on KINK FM without opening a browser. It’s a simple shell script—no dependencies beyond what you already have on a standard Unix-like system.  

## Script: `kink-songs-bash.sh`  

A plain Bash script using only `curl`, `grep`, `sed`, `printf`, and `wc`. No external tools, no Python, no Node.  

### What it does  
- Fetches the [gedraaid/kink](https://kink.nl/gedraaid/kink) page with `curl`  
- Pulls out artist and song titles from the HTML  
- Prints the last 25 tracks (adjustable) with colored, readable output  
- Supports continuous polling (e.g., `--continuous --interval 60`)  

### Dependencies  
- `bash` (comes with macOS/Linux)  
- `curl` (standard, or installable via `apt`, `brew`, etc.)  
- `grep`, `sed`, `printf`, `wc` (all POSIX)  

### Usage  

```bash
./kink-songs-bash.sh [OPTIONS]
```

### Options  

| Option | Description |
| :--- | :--- |
| `-n, --number NUM` | Songs to show (default: 25) |
| `-c, --no-colors` | Skip ANSI colors |
| `--no-header` | Hide top box |
| `--no-footer` | Hide bottom info box |
| `-q, --quiet` | Minimal output (no colors, header, or footer) |
| `--continuous` | Loop and refresh periodically |
| `--interval SEC` | Seconds between refresh (default: 30, needs `--continuous`) |
| `-h, --help` | Show this help |

### Examples  

```bash
# Default: 25 songs, colored
./kink-songs-bash.sh

# Top 10
./kink-songs-bash.sh -n 10

# Auto-refresh every minute (good for a spare terminal pane)
./kink-songs-bash.sh --continuous --interval 60

# Copy-paste friendly (no pretty boxes)
./kink-songs-bash.sh --quiet
```

### Example Output  

```
╔════════════════════════════════════════╗
║   KINK FM - Recently Played Songs      ║
╚════════════════════════════════════════╝

Found 25 recently played songs:

 1. Artist Name
    'Song Title'

 2. Another Artist
    'Another Song'

 ...

╔════════════════════════════════════════╗
║ Data source: KINK FM                   ║
║ https://kink.nl/gedraaid/kink          ║
╚════════════════════════════════════════╝
```