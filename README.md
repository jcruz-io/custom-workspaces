# Custom Workspaces

Omarchy (Quattro) bar widget that replaces `omarchy.workspaces` with:

- 10 persistent workspaces, always visible (like waybar's `persistent-workspaces`)
- A Nerd Font icon per workspace
- A dedicated icon for the focused workspace
- Empty workspaces dimmed to 50% opacity

Default icons (ported from my old waybar config):

| Workspace | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | active |
|-----------|---|---|---|---|---|---|---|---|---|----|--------|
| Codepoint | F268 | F07C0 | F048B | F01E5 | F14B | F07B | F0176 | F03D | F00D6 | F086 | F066 |

## Install

```bash
omarchy plugin add https://github.com/<user>/custom-workspaces.git --enable
omarchy plugin disable omarchy.workspaces
omarchy bar move jcruz.custom-workspaces --section left
```

Update / remove:

```bash
omarchy plugin update jcruz.custom-workspaces
omarchy plugin remove jcruz.custom-workspaces
omarchy plugin enable omarchy.workspaces   # restore the stock widget
```

## Settings

Settings live inline on the widget's entry in `~/.config/omarchy/shell.json`
(hot-reloaded on save). All are optional.

```json
{ "id": "jcruz.custom-workspaces",
  "icons": ["", "󰟀", "󰒋", "󰇥", "", "", "󰅶", "", "󰃖", ""],
  "activeIcon": "",
  "persistent": 10 }
```

| Key          | Default         | Meaning |
|--------------|-----------------|---------|
| `icons`      | table above     | 10 glyphs, index 0 = workspace 1. An empty string falls back to the number. |
| `activeIcon` | `U+F066`        | Glyph for the focused workspace. `""` keeps the workspace's own icon. |
| `persistent` | `10`            | Workspaces 1..N always shown; others appear only while they exist. |

## Development

```bash
omarchy plugin validate .
```

Installed plugins are plain git checkouts in
`~/.config/omarchy/plugins/jcruz.custom-workspaces/`; edits there hot-reload.
