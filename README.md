# muscst (Experimental / WIP)

> **Window actor buffer exclusion filter for Mutter screencast capture streams on GNOME Wayland.**

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](LICENSE)
[![Platform: Arch Linux](https://img.shields.io/badge/Platform-Arch%20Linux-brightgreen.svg)](https://archlinux.org)
[![Compositor: Mutter 50](https://img.shields.io/badge/Compositor-Mutter%2050.2-orange.svg)](https://gitlab.gnome.org/GNOME/mutter)
[![Status: In Development](https://img.shields.io/badge/Status-In%20Development%20(WIP)-yellow.svg)](https://github.com/sofyanox12/muscst)

**Maintainer:** Sofyan Pujas ([@sofyanox12](https://github.com/sofyanox12))

> [!WARNING]
> **Project Status: Early Development & Proof-of-Concept**
> `muscst` is an experimental research patch and development utility for GNOME's Mutter compositor. It is **in active development** and **not** intended for general use or production installation via `sudo pacman`. Testing should only be conducted within isolated developer virtual machines or test containers.

---

## Technical Overview

`muscst` implements selective window actor buffer exclusion during GNOME Mutter's monitor-level screencast capture passes on Wayland.

During an active screencast stream, Mutter blits compositor window actors into an offscreen framebuffer (FBO) for PipeWire delivery. `muscst` introduces an evaluation check in `MetaWindowActor`'s paint sequence: if the actor belongs to a process matched against user-defined rules (`WM_CLASS` or `app_id`), its buffer is omitted from the screencast FBO.

- The window remains fully rendered on physical KMS hardware scanout (compositor main view).
- The window's buffer is bypassed specifically during the screencast render pass.
- Hardware mouse cursor rendering remains preserved across the entire coordinate stream.
- Buffer filtering state can be dynamically toggled at runtime via `state.json` without restarting the GNOME Shell session.

---

## Features

- **Screencast Stream Buffer Filtering:** Exclude designated window actor buffers during offscreen screencast capture passes.
- **Process-Specific Targetting:** Filter windows matching application identifiers (`WM_CLASS` or `app_id`).
- **Dynamic Runtime Toggle:** Enable or disable filtering on the fly via configuration state without compositor restarts.
- **Scanout Preservation:** KMS scanout is untouched; excluded buffers remain completely visible to the local user.
- **Hardware Cursor Preservation:** Cursor sprites continue rendering smoothly across coordinates on the screencast output.
- **CLI & TUI Controller:** Lightweight Python utility (`muscst`) to manage exclusion lists and runtime state.

---

## CLI Controller Usage

The controller utility is located in `bin/muscst`.

### Interactive TUI
```bash
./bin/muscst ui
```
Navigate with arrow keys `[↑/↓]` and `[Enter]` to toggle the buffer exclusion filter, view active rules, or register process identifiers.

### Command-Line Interface

```bash
# Print current filter status and active exclusion rules
./bin/muscst status

# Enable screencast buffer exclusion filter
./bin/muscst on

# Disable buffer exclusion filter (normal full screencast)
./bin/muscst off

# Toggle filter state ON/OFF
./bin/muscst toggle

# Register a process window class to exclude
./bin/muscst add kitty
./bin/muscst add org.gnome.Nautilus

# Remove a process window class from exclusion
./bin/muscst remove kitty
```

---

## Project Structure

```text
muscst/
├── PKGBUILD                               # Arch Linux packaging recipe (mutter-muscst)
├── .SRCINFO                               # AUR packaging metadata
├── bin/
│   └── muscst                             # Standalone CLI & TUI controller executable
├── config/
│   └── state.json.example                 # Runtime configuration template
├── patches/
│   └── 0001-screencast-window-exclusion.patch # C Patch for Mutter screencast buffer exclusion
├── scripts/
│   ├── build-isolated.sh                  # Isolated build via Docker container
│   ├── test-isolated.sh                   # Headless test runner in Docker
│   ├── build.sh                           # Non-invasive build via makepkg
│   ├── install.sh                         # Developer installation helper with backup (VM only)
│   └── rollback.sh                        # Upstream Mutter recovery script
├── .github/workflows/ci.yml               # Automated CI for linting and packaging
├── CONTRIBUTING.md                        # Contribution guidelines and coding standards
├── LICENSE                                # GNU General Public License v2.0
└── README.md                              # Project documentation
```

---

## Development & Testing Workflow

> [!IMPORTANT]
> Do not attempt to install or replace your desktop compositor on your primary host machine. Mutter is the core GNOME display server; crashes or ABI issues will break your session.

### 1. Isolated Compilation (Recommended)
Compile the package inside an ephemeral Arch Linux container without polluting host packages:

```bash
./scripts/build-isolated.sh
```

### 2. Isolated Headless Testing
Test package installation, CLI controller, and Mutter's Wayland compositor headless launch safely:

```bash
./scripts/test-isolated.sh
```

### 3. Dedicated VM Testing (Full GNOME Integration)
If testing visual screencasts within a dedicated Arch Linux development virtual machine (QEMU/KVM):

```bash
./scripts/install.sh
```

Log out and log back in to your GNOME Wayland test session to initialize the patched compositor.

### Emergency Rollback
To restore the official upstream Arch Linux Mutter package inside the test environment:

```bash
./scripts/rollback.sh
```

---

## License

This project is licensed under the **GNU General Public License v2.0 (GPL-2.0-or-later)** to remain fully compliant with upstream GNOME Mutter licensing. See [LICENSE](LICENSE) for details.
