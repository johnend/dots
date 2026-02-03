# QMK Firmware Context

**Project Path:** `/Users/john.enderby/Developer/personal/qmk_firmware`

## Overview

QMK (Quantum Mechanical Keyboard) Firmware is an open-source keyboard firmware based on tmk_keyboard. This is a personal fork containing custom keyboard layouts, specifically for the Sofle RGB keyboard with a custom "johnend" keymap. The firmware supports Atmel AVR and ARM controllers and is used to program mechanical keyboards with custom key mappings, RGB lighting, and advanced features.

## Tech Stack

### Core
- **Language:** C (embedded)
- **Compiler:** AVR-GCC 8.5.0 (Homebrew)
- **Build Tool:** GNU Make 3.81
- **Target Platform:** Atmel AVR microcontrollers (primarily ATmega32U4)
- **Firmware Base:** tmk_keyboard

### Key Dependencies
- **Python CLI:** QMK CLI 1.1.8
  - argcomplete - Command line completion
  - colorama - Terminal colors
  - hjson - Human JSON parser
  - jsonschema>=4 - Keyboard configuration validation
  - milc>=1.9.0 - QMK CLI framework
  - pyserial - Serial communication for flashing
  - pyusb - USB device communication
  - pillow - Image processing for OLED displays

### Dev Tools
- **Build System:** Make-based with custom QMK build system
- **Linting:** clang-format (`.clang-format` configured)
- **LSP Support:** clangd (`.clangd` configured)
- **Editor Config:** EditorConfig support (`.editorconfig`)
- **Testing:** Native test framework in `tests/` directory
- **Flashing:** avrdude, dfu-programmer, or Teensy Loader

## Project Structure

```
qmk_firmware/
├── keyboards/           # Keyboard-specific configurations
│   └── sofle/          # Sofle keyboard
│       └── keymaps/    # Keymap configurations
│           └── johnend/ # Custom keymap (yours)
│               ├── keymap.c
│               ├── config.h
│               ├── rules.mk
│               └── MODIFICATIONS.md
├── quantum/             # QMK core functionality
├── tmk_core/           # TMK keyboard core
├── drivers/            # Hardware drivers
├── platforms/          # Platform-specific code (AVR, ARM, etc.)
├── lib/                # Third-party libraries
├── users/              # User-specific code shared across keyboards
├── layouts/            # Standard layout definitions
├── docs/               # Documentation (VitePress)
├── tests/              # Test suite
├── util/               # Utility scripts
├── builddefs/          # Build system definitions
├── .build/             # Build output directory
├── Makefile            # Main build file
├── requirements.txt    # Python dependencies
└── sofle_rev1_johnend.hex  # Compiled firmware (your keymap)
```

## Scripts

### Building Firmware

**⚠️ IMPORTANT: Always use QMK CLI, NOT Make directly**

```bash
qmk compile -kb sofle/rev1 -km johnend    # Build Sofle keyboard with johnend keymap
qmk compile -kb <keyboard> -km <keymap>   # Build any keyboard with any keymap
```

**Do NOT use:**
```bash
make sofle:johnend   # ❌ WRONG - causes Xcode path issues on macOS
```

### Flashing Firmware

```bash
qmk flash -kb sofle/rev1 -km johnend      # Build and flash to keyboard
```

### QMK CLI Commands

```bash
qmk compile                    # Compile current keyboard
qmk flash                      # Compile and flash
qmk config                     # View/edit QMK configuration
qmk setup                      # Setup QMK environment
qmk doctor                     # Check environment setup
qmk list-keyboards             # List all supported keyboards
qmk new-keymap                 # Create new keymap from default
```

### Testing

```bash
qmk pytest                     # Run all tests
qmk pytest -t <test_name>      # Run specific test
```

### Cleanup

```bash
qmk clean                      # Clean build artifacts
qmk clean -a                   # Deep clean all builds
```

## Development Setup

### Prerequisites
- **AVR toolchain:** avr-gcc, avr-libc, avrdude
- **Python 3.6+** with pip
- **Make** (GNU Make)
- **Git**
- **QMK CLI** (installed via pip)

### Setup Steps

1. **Install QMK CLI:**
   ```bash
   python3 -m pip install --user qmk
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Setup QMK environment:**
   ```bash
   qmk setup
   qmk doctor  # Verify installation
   ```

4. **Install AVR toolchain (macOS):**
   ```bash
   brew install avr-gcc avrdude
   ```

5. **Build your keymap:**
   ```bash
   qmk compile -kb sofle/rev1 -km johnend
   ```

6. **Flash to keyboard:**
   - Run: `qmk flash -kb sofle/rev1 -km johnend`
   - Put keyboard in bootloader mode when prompted (press reset button)

## Custom Keymap: johnend

**Location:** `keyboards/sofle/keymaps/johnend/`

**Files:**
- `keymap.c` - Custom key layout with layer definitions
- `config.h` - Configuration overrides
- `rules.mk` - Feature flags (RGB, OLED, etc.)
- `MODIFICATIONS.md` - Documentation of changes

**Built Firmware:** `sofle_rev1_johnend.hex` (75,798 bytes)

**Features in johnend keymap:**
- Custom RGB lighting configurations
- Layer-based lighting indicators
- Numpad layer
- Navigation layer
- Custom macros and key combinations

## Testing Strategy

- **Unit tests:** Located in `tests/` directory
- **Test framework:** Custom C-based test harness
- **Test organization:** Tests organized by feature (tap_hold, combo, caps_word, etc.)
- **Run tests:** `make test` or `make test:<specific_test>`

## Documentation

- **Official docs:** https://docs.qmk.fm
- **Local docs:** Available in `docs/` directory (VitePress-based)
- **API reference:** Auto-generated Doxygen documentation
- **Discord:** https://discord.gg/qmk
- **GitHub:** https://github.com/qmk/qmk_firmware

## Flashing Process

1. Build and flash: `qmk flash -kb sofle/rev1 -km johnend`
2. Wait for prompt, then put keyboard in bootloader mode:
   - For Sofle: Press reset button on PCB
   - Or use QMK_BOOT keycode if configured
3. Wait for completion (LEDs will flash)
4. Keyboard will restart with new firmware

**Alternative (compile only):**
- Compile: `qmk compile -kb sofle/rev1 -km johnend`
- Flash manually with QMK Toolbox or avrdude

## Key Patterns

### Keymap Structure
- Keymaps defined as 2D arrays in `keymap.c`
- Layers stacked (base, lower, raise, adjust, etc.)
- Use `LT()`, `MO()`, `TG()` for layer switching
- Custom keycodes can be defined for macros

### RGB Configuration
- RGB matrix effects configured in `config.h`
- Per-layer lighting in `layer_state_set_user()`
- Custom lighting macros for indicators, underglow, etc.

### Build System
- Uses Make with recursive submakes
- Keyboard-specific rules in `keyboards/<keyboard>/rules.mk`
- Keymap-specific rules in `keyboards/<keyboard>/keymaps/<keymap>/rules.mk`
- Feature flags enable/disable functionality at compile time

### File Organization
- Keyboard hardware definitions in `keyboards/`
- Core QMK code in `quantum/`
- User-shareable code in `users/<username>/`
- Platform abstractions in `platforms/`

## Important Notes

### Git Workflow
- **Upstream:** https://github.com/qmk/qmk_firmware (official QMK repo)
- **Origin:** https://github.com/johnend/qmk_firmware.git (your fork)
- Keep fork synced with upstream for updates
- Custom changes live in `keyboards/sofle/keymaps/johnend/`

### Compilation Tips
- **Always use `qmk compile`, never `make` directly** (avoids Xcode path issues on macOS)
- First build can take 5-10 minutes
- Subsequent builds are much faster (incremental)
- Clean build if experiencing issues: `qmk clean`
- Build artifacts in `.build/` (gitignored)
- QMK CLI handles toolchain detection automatically

### Flashing Safety
- Always backup working `.hex` file before flashing
- If flash fails, keyboard may be bricked (recoverable via bootloader)
- Test firmware in safe environment before daily use
- Keep a known-good firmware handy

### Submodules
- Uses git submodules for some libraries (see `.gitmodules`)
- Run `git submodule update --init --recursive` after cloning

### Binary Files
- Compiled `.hex` files are firmware binaries (not tracked in upstream)
- Your compiled firmware: `sofle_rev1_johnend.hex` (present in repo)
- These can be flashed directly without rebuilding

### VS Code Support
- `.vscode/` directory contains editor configuration
- Recommended extensions in `.vscode/extensions.json`
- IntelliSense configured for embedded C development

### Keyboard-Specific Notes
- **Sofle:** Split keyboard with OLED displays and RGB underglow
- **MCU:** ATmega32U4 (standard for most hobby keyboards)
- **Bootloader:** Caterina or DFU (check specific board)
- **Communication:** Uses serial connection between halves

## Related Resources

- **QMK Configurator:** https://config.qmk.fm (web-based keymap editor)
- **QMK Toolbox:** GUI for flashing firmware
- **Keyboard Layouts:** http://www.keyboard-layout-editor.com
- **Sofle Keyboard:** https://josefadamcik.github.io/SofleKeyboard/
