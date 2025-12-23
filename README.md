# KINK FM Recently Played Songs

This project provides two shell scripts to fetch and display the most recently played songs from the KINK FM radio station website ([kink.nl/gedraaid/kink](https://kink.nl/gedraaid/kink)) directly in your terminal.

## Scripts

There are two versions of the script, each using a different approach:

### `kink-songs.sh` (Bash with Embedded Python)

This script uses `bash` to execute an embedded `python3` script. The Python script handles:
- Fetching the KINK FM "gedraaid" (played) page.
- Parsing the HTML to extract the JSON data containing the `playedTracks`.
- Unescaping and formatting the song titles and artists.
- Displaying the last 25 songs with colorful output.

**Dependencies:**
- `bash` (standard on most Unix-like systems)
- `python3` (with standard libraries `json`, `re`, `urllib.request`)

**How to Run:**
```bash
./kink-songs.sh
```

### `kink-songs-bash.sh` (Pure Bash with cURL and Standard Tools)

This script is a pure `bash` implementation, relying only on `curl` and standard Unix text processing utilities like `grep`, `sed`, `printf`, and `wc`. It performs:
- Fetching the KINK FM "gedraaid" page using `curl`.
- Extracting and unescaping track data directly from the HTML using `sed` and `grep`.
- Formatting and displaying the last 25 songs with colorful output.

**Dependencies:**
- `bash` (standard)
- `curl` (usually pre-installed or easily installable)
- Standard Unix utilities (`grep`, `sed`, `printf`, `wc`)

**How to Run:**
```bash
./kink-songs-bash.sh
```

## Example Output

Both scripts produce similar colorful output, like this (colors may vary slightly depending on your terminal):

```
╔════════════════════════════════════════╗
║   KINK FM - Recently Played Songs      ║
╚════════════════════════════════════════╝

Found 25 recently played songs:

 1. Artist Name
    'Song Title'

 2. Another Artist
    'Another Song'

 ... (up to 25 songs) ...

╔════════════════════════════════════════╗
║ Data source: KINK FM                   ║
║ https://kink.nl/gedraaid/kink          ║
╚════════════════════════════════════════╝
```
