---
name: type
description: Use wtype to type the user's exact requested output into the currently selected input field. Use when the user asks you to type text into whatever is selected.
compatibility: Linux Wayland session with wtype available.
---

# Type into the selected field

Use this skill when the user wants text typed into the currently focused or selected input field.

## Behavior

- The user's prompt is the instruction for what should be typed.
- The content you output should be the exact text to type.
- Keep the response concise and directly usable.
- Prefer typing the final content with `wtype`.

## Required flow

1. Convert the user's instruction into the text that should be typed.
2. Copy or type that text with `wtype`.
3. Confirm briefly that the text was entered.

## Tooling

Use `nix-shell` when `wtype` is not already available:

```bash
nix-shell -p wtype --run 'wtype "hello world"'
```

If clipboard assistance is useful:

```bash
nix-shell -p wl-clipboard --run 'wl-copy "hello world"'
```

## Notes

- This skill is for typing text into the user's selected field.
- If the input target is not focused, ask the user to focus it first.
- Do not invent extra content beyond what the user asked to type.
