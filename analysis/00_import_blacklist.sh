#!/bin/bash
# Arguments: day to import in the form yyyy-mm-dd

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
intelmq_dir="${dir}/../intelmq"

day=$1

echo "Importing data for blacklist [intelmq] for [$day]."
cat $intelmq_dir/$day*events.log | $VAST import bro 'classification.type == "spam"'
