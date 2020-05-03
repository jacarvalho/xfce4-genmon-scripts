#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk, procps-ng

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/uptime/arrow-up.png"

# Calculate uptime
readonly UPTIME=`uptime | awk -F'( |,|:)+' '{d=h=m=0; if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0"d:"h+0"h:"m+0"m"}'`

# Panel
if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
  INFO="<img>${ICON}</img>"
  INFO+="<txt>"
else
  INFO="<txt>"
fi
INFO+="${UPTIME}"
INFO+="</txt>"

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+=""
MORE_INFO+="</tool>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
