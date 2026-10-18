<div align="center">

# fluxbox-optimal

**A fast, keyboard-first Fluxbox desktop in Tokyo Night — with [tubetui](https://github.com/polblancoo/tubetui) (YouTube in your terminal) built in.**

Fluxbox · kitty · rofi · picom · dunst · conky · NvChad · superfile

[Español](README.es.md) · MIT licensed

</div>

---

## What you get

- **Tokyo Night everywhere**: Fluxbox style, kitty, rofi, dunst, conky.
- **Keyboard-first**: `Win` launchers, a vim-style window mode (`Win+R`), half-screen tiling, a drop-down terminal (`F12`) and a built-in cheat sheet (`Win+?` or `Alt+F12`).
- **tubetui on `Win+Y`**: YouTube, subscriptions, local music/videos, video embedded in kitty.
- **Quality-of-life scripts** (all in `fluxbox/scripts/`, plain shell):
  audio output picker (`Win+A`), Bluetooth menu (`Win+Shift+B`), power menu (`Win+X`), study mode with pomodoro (`Win+E`), movie mode (`Win+M`), night light, compositor toggle, project launcher (`Win+O`), web search (`Win+S`), clipboard history (`Win+V`).
- **Screenshots** (`PrtSc`, `Shift+PrtSc`) with flameshot, **brightness** keys (`Win+PgUp/PgDn` too), **USB auto-mount** with udiskie.
- **kitty with a logo**, powerline tabs and hint kittens (open URLs and `file:line` errors in nvim).
- **Basic conky**: clock, CPU, RAM, network, disk, top processes.
- **NvChad** as the editor and **superfile (`spf`)** as the terminal file manager (`Win+F`).

## Install

Tested on Debian/Ubuntu-family systems (needs `apt`; on other distros install the packages from `packages-apt.txt` by hand and run the script).

```sh
git clone https://github.com/polblancoo/fluxbox-optimal
cd fluxbox-optimal
./install.sh --dry-run   # see what it would do
./install.sh
```

The installer backs up anything it replaces (`~/.fluxbox.bak-<date>`, …), never touches your wallpaper, and asks before downloading the Nerd Font or NvChad.
Then log out and pick **Fluxbox** at the login screen.

### Optional pieces (not installed automatically)

| Tool | How |
|---|---|
| tubetui | `cargo install tubetui` (needs [Rust](https://rustup.rs)) |
| superfile (`spf`) | https://superfile.dev |
| greenclip (clipboard history) | releases of https://github.com/erebe/greenclip |
| aMule | `sudo apt install amule` (it is in the menu) |
| Wallpaper | drop an image at `~/.fluxbox/wallpaper.jpg` or `.png` |

## Key bindings

`Win` = Super key. Press **`Win + ?`** (or `Alt + F12`) for the full cheat sheet; the highlights:

| Keys | Action |
|---|---|
| `Win+Enter` / `F12` | terminal / drop-down terminal |
| `Win+P` / `Win+W` | app launcher / window switcher (rofi) |
| `Win+B` / `Win+N` / `Win+F` | browser / nvim / files (spf) |
| `Win+Y` | **tubetui** |
| `Win+R` then `h j k l` | move windows vim-style |
| `Win+Shift+←/→` | tile left / right |
| `PrtSc` | screenshot (flameshot) |
| `Win+A` | audio output |
| `Win+X` | power menu |

> The `Win+?` binding uses keycode 20, which is the `?` key on Spanish/Latin-American layouts. On other layouts use `Alt+F12`, or edit `fluxbox/keys` (find your keycode with `xev`).

## Layout

```
fluxbox/   → ~/.fluxbox    init, keys, menu, apps, startup, styles/, scripts/, help.sh
config/    → ~/.config     kitty, rofi, dunst, picom, conky
install.sh                 installer (--dry-run, --yes)
packages-apt.txt           package list
```

Paths in the repo use `$HOME` or a placeholder that `install.sh` fills in; there is nothing machine-specific to edit.

## Credits

Tokyo Night palette by [enkia](https://github.com/enkia/tokyo-night-vscode-theme). Logo: Tux by Larry Ewing. NvChad, superfile, picom, rofi, flameshot, kitty and Fluxbox belong to their authors.

## License

MIT — see [LICENSE](LICENSE).
