# VS Code Downgrade: 1.140.0 → 1.139.0

Context: VS Code auto-updated to 1.140.0 overnight (2026-09-30), which lines up with drag-and-drop breaking and the Shift-drag outline indicator not showing. Verified version `1.139.0` (build `2242ebbb54efeeb0129e08e919e7e8d43033cd83`).


## Steps

1. **Quit VS Code completely** (Cmd+Q, not just close the window).

2. Open Terminal.app and run:

   ```bash
   # download v1.139.0
   curl -L -o ~/Downloads/Software/VSCode-1.139.0-darwin-arm64.zip "https://update.code.visualstudio.com/1.139.0/darwin-arm64/stable"

   # Unzip
   ditto -x -k ~/Downloads/Software/VSCode-1.139.0-darwin-arm64.zip ~/Downloads/Software/vscode-1.139.0

   # install 1.139.0
   mv ~/Downloads/Software/vscode-1.139.0/"Visual Studio Code.app" "/Applications/Visual Studio Code.app"

   # back up the current 1.140.0 build (don't delete — reversible)
   mv "/Applications/Visual Studio Code.app" "/Applications/Visual Studio Code 1.140.0.bak.app"

   # install 1.139.0
   mv ~/Downloads/Software/vscode-1.139.0/"Visual Studio Code.app" "/Applications/Visual Studio Code.app"
   ```

3. **Disable auto-update** so it doesn't silently jump back to 1.140.0 overnight:

   ```bash
   python3 -c "
   import json
   p = '$HOME/Library/Application Support/Code/User/settings.json'
   d = json.load(open(p))
   d['update.mode'] = 'none'
   json.dump(d, open(p, 'w'), indent=4)
   "
   ```

4. Relaunch VS Code. Confirm via `Code > About Visual Studio Code` that it says **1.139.0**.

5. Re-test drag-and-drop in the Explorer and the Shift-drag outline indicator.

## After testing

- **Fixed on 1.139.0** → confirms a 1.140.0 regression. File it at
  `https://github.com/microsoft/vscode/issues` with both build hashes:
  - 1.140.0 (broken): `07f806f999227108933c2e30515b26eecc1fda74`
  - 1.139.0 (working): `2242ebbb54efeeb0129e08e919e7e8d43033cd83`
- **Still broken** → not a core regression. Next step: bisect the extensions that updated the same
  day (`parth.parth-0.1.0`, `openai.chatgpt`, `openai.codex-audio`) by launching with
  `"/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" --disable-extensions`.

## Revert (if needed)

```bash
mv "/Applications/Visual Studio Code.app" "/Applications/Visual Studio Code 1.139.0.bak.app"
mv "/Applications/Visual Studio Code 1.140.0.bak.app" "/Applications/Visual Studio Code.app"
```
