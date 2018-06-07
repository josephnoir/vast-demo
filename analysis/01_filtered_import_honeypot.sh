#!/bin/bash
# Arguments: day to import in the form yyyy-mm-dd

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
honeypot_dir="${dir}/../honeypot"

day=$1

str_filter=""
for i in $($VAST export bro "&type == \"bro::blacklist\"" | bro-cut -d source.network | grep "/" | sort -u)
do
  str_filter="${str_filter}|| id.orig_h in ${i} "
done

num_prefix=$(grep -o "||" <<< "${str_filter}" | wc -l)
echo "${day} | Num of Blacklist Prefixes for Honeypot Import: ${num_prefix}"

str_filter=$(echo "${str_filter}" | cut -c 4-)
gunzip -c ${honeypot_dir}/*_conn_log_${day}.bro.gz | $VAST import bro ${str_filter}
