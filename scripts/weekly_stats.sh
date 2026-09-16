#!/bin/bash
#
# weekly_stats.sh
# Loads the last 7 days of forecast accuracy values from
# synthetic_historical_fc_accuracy.tsv into an array, converts any
# negative values to their absolute value, then calculates and
# reports the minimum and maximum absolute forecast error for the week.

echo $(tail -7 synthetic_historical_fc_accuracy.tsv | cut -f6) > scratch.txt

week_fc=($(echo $(cat scratch.txt)))

# validate result:
for i in {0..6}; do
    echo ${week_fc[$i]}
done

for i in {0..6}; do
  if [[ ${week_fc[$i]} -lt 0 ]]
  then
    week_fc[$i]=$(((-1)*week_fc[$i]))
  fi
  # validate result:
  echo ${week_fc[$i]}
done

minimum=${week_fc[1]}
maximum=${week_fc[1]}
for item in ${week_fc[@]}; do
   if [[ $minimum -gt $item ]]
   then
     minimum=$item
   fi
   if [[ $maximum -lt $item ]]
   then
     maximum=$item
   fi
done

echo "minimum absolute error = $minimum"
echo "maximum absolute error = $maximum"
