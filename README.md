# Guess My Number (Flutter Web)

A clean Flutter web game where players guess a secret number between 1 and 100.

## Features
- Flutter web UI with responsive layout
- Best score saved in browser localStorage
- Keyboard support (Enter to submit)

## Install Flutter
Follow the official docs for your OS:
- https://docs.flutter.dev/get-started/install

Quick overview:
- **macOS:** `brew install --cask flutter`
- **Windows:** download the Flutter SDK zip, add `flutter/bin` to PATH
- **Linux:** download the Flutter SDK tarball, add `flutter/bin` to PATH

Verify:
```bash
flutter --version
```

## Local Development
```bash
# Get dependencies
flutter pub get

# Run in Chrome
flutter run -d chrome
```

## Build for Web
```bash
flutter build web
```
This outputs static files in `build/web/`.

## Deploy Options
### 1) GitHub Pages
```bash
flutter build web --base-href "/guess-my-number/"
```
Then deploy the `build/web` folder to GitHub Pages (e.g., via a `gh-pages` branch or GitHub Actions).

### 2) Vercel
- Build command: `flutter build web`
- Output directory: `build/web`

### 3) Netlify
- Build command: `flutter build web`
- Publish directory: `build/web`

## Security Note
Because the game runs entirely in the browser, the secret number exists in JavaScript memory. A user can inspect or debug the page to discover it. This is normal for client‑side games. If you need a truly hidden number, you must generate and validate guesses on a server.

## Theme Ideas
- Retro arcade: pixel fonts, CRT glow
- Cricket stadium: guesses as runs
- Space mission: guess the launch code
- Treasure hunt: heat‑map hints
- Daily challenge mode
- Timed mode
- Multiplayer pass‑and‑play

## License
MIT
