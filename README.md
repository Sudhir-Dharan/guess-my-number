# Guess My Number

A clean, single‑file browser game where players guess a secret number between 1 and 100. Designed to be easy to embed on a blog site.

## Features
- Single HTML file (drop‑in anywhere)
- Responsive UI
- Best score saved in localStorage
- Keyboard support (Enter to submit)

## How to Run
**Option 1: Just open the file**
1. Download `index.html`
2. Double‑click it to open in your browser

**Option 2: Run a local server (optional)**
```bash
# Python
python -m http.server 8000

# Or Node
npx serve .
```
Then open `http://localhost:8000`.

## Security Note
Because the game runs entirely in the browser, the secret number exists in JavaScript memory. A user can inspect or debug the page to discover it. This is normal for client‑side games. If you need a truly hidden number, you must generate and validate guesses on a server.

## Theme Ideas (to make it more interesting)
- **Retro arcade**: pixel fonts, CRT glow, synthwave colors
- **Cricket stadium**: guesses as runs, crowd reactions for hints
- **Space mission**: guess the launch code, oxygen bar as attempts
- **Treasure hunt**: map animation, closer/farther heat hints
- **Minimal Zen**: monochrome palette, subtle sounds
- **Daily challenge**: one number per day, share results
- **Timed mode**: countdown clock, bonus points for speed
- **Multiplayer pass‑and‑play**: two players alternate guesses

## License
MIT
