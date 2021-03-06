#!/bin/bash

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bgp_dir="$dir/bgp/routeviews"
bgp_url="http://archive.routeviews.org"

mkdir $bgp_dir
ls $bgp_dir

if [[ "$OSTYPE" == "darwin"* ]]; then
  download_updates () {
    year=$1
    month=$2
    day=$3

    collectors=(
      "route-views3"
      "route-views4"
      "route-views.eqix"
      "route-views.jinx"
      "route-views.linx"
    )

    for cl in "${collectors[@]}"
    do
      mkdir -p "${bgp_dir}/${cl}"
      for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
      do
        for j in 00 15 30 45
        do
          filename="updates.${year}${month}${day}.${i}${j}.bz2"
          curl -o ${bgp_dir}/${cl}/${filename} ${bgp_url}/${cl}/bgpdata/${year}.${month}/UPDATES/${filename}
        done
      done
    done
  }
else
  download_updates () {
    year=$1
    month=$2
    day=$3

    collectors=(
      "route-views3"
      "route-views4"
      "route-views.eqix"
      "route-views.jinx"
      "route-views.linx"
    )

    for cl in "${collectors[@]}"
    do
      mkdir "${bgp_dir}/${cl}"
      parallel -j 8 wget -N -P "${bgp_dir}/${cl}" ::: \
        "${bgp_url}/${cl}/bgpdata/${year}.${month}/UPDATES/updates.${year}${month}${day}."{00..23}{00..45..15}".bz2"
    done
  }
fi

# download_updates "2018" "06" "01"
download_updates "2018" "06" "02"
download_updates "2018" "06" "03"
download_updates "2018" "06" "04"
download_updates "2018" "06" "05"
download_updates "2018" "06" "06"
