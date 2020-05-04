#!/usr/bin/env bash
# Dependencies: bash>=3.2, coreutils, file, gawk, grep, lm_sensors, sed, xfce4-taskmanager

# Makes the script more portable
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optional icon to display before the text
# Insert the absolute path of the icon
# Recommended size is 24x24 px
readonly ICON="${DIR}/icons/gpu/gpu-white.png"

# GPU Information
GPUENABLED=false
GPUINFO="NO GPU"
if [[ $(nvidia-smi) != *"has failed"* ]]; then
  GPUENABLED=true
  # Parse GPU info
  GPUINFOARRAY=$(nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total --format=csv,noheader,nounits -d MEMORY)
  IFS=', ' read -r -a GPUINFOARRAY <<< "${GPUINFOARRAY}"
  GPUUSE=${GPUINFOARRAY[0]}
  GPUMEMUSE=${GPUINFOARRAY[1]}
  GPUMEMTOT=${GPUINFOARRAY[2]}

  calc(){ awk "BEGIN { print "$*" }"; }

  GPUUSE=$(printf "%2.1f" ${GPUUSE} | tr , .)
  GPUMEMUSE=$(bc <<< "scale=1; ${GPUMEMUSE}/1000")
  GPUMEMTOT=$(bc <<< "scale=1; ${GPUMEMTOT}/1000")
  GPUINFO=$(echo ${GPUUSE}% - ${GPUMEMUSE}G/${GPUMEMTOT}G)
fi


# Tooltip
MORE_INFO="<tool>"
if [ "${GPUENABLED}" = true ]; then
  GPUNAME=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits)
  MORE_INFO+="┌ ${GPUNAME} \n" # GPU NAME
  GPUTEMP=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)
  MORE_INFO+="└─ Temperature: +${GPUTEMP}\xE2\x84\x83"
fi
MORE_INFO+="</tool>"

# Panel
if [[ $(file -b "${ICON}") =~ PNG|SVG ]]; then
  INFO="<img>${ICON}</img>"
  if hash nvidia-settings  &> /dev/null; then
    INFO+="<click>nvidia-settings</click>"
  fi
  INFO+="<txt>"
else
  INFO="<txt>"
fi
INFO+="${GPUINFO}"
INFO+="</txt>"

# Panel Print
echo -e "${INFO}"

# Tooltip Print
echo -e "${MORE_INFO}"
