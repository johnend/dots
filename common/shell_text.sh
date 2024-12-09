# colors.sh

# Text Treatments
export RESET="\033[0m"        # Reset all attributes
export BOLD="\033[1m"         # Bold text
export DIM="\033[2m"          # Dim (faint) text
export UNDERLINE="\033[4m"    # Underlined text
export BLINK="\033[5m"        # Blinking text (may not be supported)
export REVERSE="\033[7m"      # Reversed (invert foreground/background)
export HIDDEN="\033[8m"       # Hidden text

# Standard Terminal Colors
export BLACK="\033[30m"       # Black
export RED="\033[31m"         # Red
export GREEN="\033[32m"       # Green
export YELLOW="\033[33m"      # Yellow
export BLUE="\033[34m"        # Blue
export MAGENTA="\033[35m"     # Magenta
export CYAN="\033[36m"        # Cyan
export WHITE="\033[37m"       # White
export GREY="\033[38;5;250m"       # White

# Extended ANSI Colors (256 Colors)
# Foreground colors (0-255)
for i in {0..255}; do
  export COLOR_$i="\033[38;5;${i}m"
done
