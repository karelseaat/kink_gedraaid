# KINK FM Recently Played Songs

This project provides a shell script to fetch and display the most recently played songs from the KINK FM radio station website ([kink.nl/gedraaid/kink](https://kink.nl/gedraaid/kink)) directly in your terminal.

## Script: `kink-songs-bash.sh`

This script is a pure `bash` implementation, relying only on `curl` and standard Unix text processing utilities like `grep`, `sed`, `printf`, and `wc`.

### Features
- Fetches the KINK FM "gedraaid" page using `curl`.
- Extracts and formats song titles and artists.
- Displays the last 25 songs (customizable) with colorful output.
- **Continuous Mode:** Can run in a loop to keep the list updated.
- **Customizable Output:** Options to disable colors, headers, footers, or enable quiet mode.

### Dependencies
- `bash` (standard on most Unix-like systems)
- `curl` (usually pre-installed or easily installable)
- Standard Unix utilities (`grep`, `sed`, `printf`, `wc`)

### Usage

```bash
./kink-songs-bash.sh [OPTIONS]
```

### Options

| Option | Description |
| :--- | :--- |
| `-n, --number NUM` | Number of songs to display (default: 25) |
| `-c, --no-colors` | Disable colored output |
| `--no-header` | Disable header display |
| `--no-footer` | Disable footer display |
| `-q, --quiet` | Minimal output (header/footer/colors disabled) |
| `--continuous` | Enable continuous mode with periodic refresh |
| `--interval SEC` | Refresh interval in seconds (default: 30, requires --continuous) |
| `-h, --help` | Show help message |

### Examples

**Display default (25) songs with colors:**
```bash
./kink-songs-bash.sh
```

**Display top 10 songs:**
```bash
./kink-songs-bash.sh -n 10
```

**Run continuously, refreshing every 60 seconds:**
```bash
./kink-songs-bash.sh --continuous --interval 60
```

**Minimal output (just the list):**
```bash
./kink-songs-bash.sh --quiet
```

## Example Output

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