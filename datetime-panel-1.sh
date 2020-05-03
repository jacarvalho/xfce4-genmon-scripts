#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk, procps-ng

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/datetime/clock.png"

# Calculate datetime values
readonly TIME=$(LC_ALL=en_US.UTF-8 date +%T)
readonly DATE=$(LC_ALL=en_US.UTF-8 date +%A\ %d\ %B\ %Y)
readonly DATETIME=$(LC_ALL=en_US.UTF-8 date +"%d-%b %H:%M")

# Panel
if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
  INFO="<img>${ICON}</img>"
  INFO+="<txt>"
else
  INFO="<txt>"
fi
INFO+="${DATETIME}"
INFO+="</txt>"

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="${DATE}"
MORE_INFO+="</tool>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
