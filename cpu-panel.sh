#!/usr/bin/env bash

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/cpu/chip.png"

# Array of available logical CPUs
declare -ra CPU_ARRAY=($(awk '/MHz/{print $4}' /proc/cpuinfo | cut -f1 -d"."))
# Number of logical CPU
readonly NUM_OF_CPUS="${#CPU_ARRAY[@]}"

# Tooltip
MORE_INFO="<tool>"
MORE_INFO+="┌ $(grep "model name" /proc/cpuinfo | cut -f2 -d ":" | sed -n 1p | sed -e 's/^[ \t]*//')\n" # CPU vendor, model, clock
STEP=0 # to generate CPU numbers (eg. CPU0, CPU1 ...)
for CPU in "${CPU_ARRAY[@]}"; do
  STDOUT=$(( STDOUT + CPU ))
  MORE_INFO+="├─ CPU ${STEP}: ${CPU} MHz\n"
  let STEP+=1
done
MORE_INFO+="└─ Temperature: $(sensors | awk '/[Pp]ackage/{print $4}')"
MORE_INFO+="</tool>"
STDOUT=$(( STDOUT / NUM_OF_CPUS )) # calculate average clock speed
STDOUT=$(awk '{$1 = $1 / 1024; printf "%.2f%s", $1, " GHz"}' <<< "${STDOUT}")

# Panel
if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
  INFO="<img>${ICON}</img>"
  INFO+="<txt>"
else
  INFO="<txt>"
fi
INFO+="${STDOUT}"
INFO+="</txt>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"