#!/bin/bash
# Arguments: day to import in the form yyyy-mm-dd

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bgp_dir="${dir}/../bgp/routeviews"

day=$1
short_day=${day//-}

{

str_filter=""
for i in $(vast export bro "&type == \"bro::conn\"" | bro-cut -d id.orig_h | grep "." | sort -u)
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
  for j in 00 15 30 45
  do
    for router in ${bgp_dir}/route-view* ;
    do
      echo "bzip2 -cd ${router}/updates.${short_day}.${i}${j}.bz2 | vast import mrt \"$str_filter\"" >> .commands.txt
    done
  done
done

cat .commands.txt | while read i; do printf "%q\n" "$i"; done | xargs -n 24 bash -c

rm .commands.txt

} 2>/dev/null
