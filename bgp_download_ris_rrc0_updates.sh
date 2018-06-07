#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bgp_dir="$dir/bgp"
bgp_url="http://data.ris.ripe.net/rrc00"

ls $bgp_dir

download_updates () {
 
  year=$1
  month=$2
  day=$3

  parallel -j 4 wget -N -P ${bgp_dir} ::: \
    "${bgp_url}/${year}.${month}/updates.${year}${month}${day}."{00..23}{00..55..5}".gz"
}

download_updates "2018" "05" "29"
download_updates "2018" "05" "30"
