#!/bin/bash
# Arguments: day to import in the form yyyy-mm-dd

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bgp_dir="${dir}/../bgp"

day=$1
short_day=${day//-}

{

str_filter=""
for i in $($VAST export bro "&type == \"bro::conn\"" | bro-cut -d id.orig_h | grep "." | sort -u)
do
  str_filter="$str_filter|| $i in prefix "
done

num_ip=$(grep -o "||" <<< "$str_filter" | wc -l)
echo "$day | Num of Honeypot IPs for MRT Import: $num_ip"
if [ "$n_orig" == "0" ]; then
  exit
fi

str_filter=$(echo "$str_filter" | cut -c 4-)

for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
do
  echo "gunzip -c ${bgp_dir}/updates.${short_day}.${i}*.gz | $VAST import mrt \"$str_filter\"" >> .commands.txt
done

#cat .commands.txt | while read i; do printf "%q\n" "$i"; done | xargs --max-procs=24 -I CMD bash -c CMD

#rm .commands.txt

} 2>/dev/null
