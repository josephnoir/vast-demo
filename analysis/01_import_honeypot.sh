#!/bin/bash
# Arguments: day to import in the form yyyy-mm-dd

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
honeypot_dir="${dir}/../honeypot"

day=$1

for sensor in "dark" "univ"
do
  echo "Importing data for honeypot [$sensor] and date [$day]."
  gunzip -c ${honeypot_dir}/${sensor}_conn_log_${day}.bro.gz | \
    vast import bro "id.resp_h == 91.216.216.10 || id.resp_h == 141.22.213.43"
done
