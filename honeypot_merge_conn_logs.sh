#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

hp_dir="/users/localadmin/persistent_vast/raw_logs/honeypot"
hp_tags=(
  "dark"
  "univ"
)
out_dir="$dir/honeypot"

merge_logs () {

  year=$1
  month=$2
  day=$3
  ts="${year}-${month}-${day}"

  # find logs for both sensors
  for tag in "${hp_tags[@]}"
  do
    hp_out="${out_dir}/${tag}_conn_log_${ts}.bro"

    # create output file and with bro header
    for log in $(find "${hp_dir}" | grep "${ts}" | grep "${tag}" | grep "conn\." | head -n 1)
    do
      zcat ${log} | head -n 8 > "${hp_out}"
    done

    # let us merge bro connection logs (drop bro header and trailer)
    for log in $(find "${hp_dir}" | grep "${ts}" | grep "${tag}" | grep "conn\.")
    do
      zcat ${log} | grep -v "#" >> "${hp_out}"
    done

    # zip logfile, removes uncompressed file
    gzip -f "${hp_out}"
  done
}

merge_logs "2018" "06" "03"
merge_logs "2018" "06" "02"
merge_logs "2018" "06" "01"
merge_logs "2018" "05" "31"
merge_logs "2018" "05" "30"
merge_logs "2018" "05" "29"
