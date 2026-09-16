#!/bin/bash
#
# rx_poc.sh
# Pulls current + forecasted temperature for a city from wttr.in,
# extracts the relevant values, and appends a tab-delimited record
# to rx_poc.log. Scheduled via cron to run daily (see crontab entry).

city=Casablanca

# Pull the raw weather report
curl -s wttr.in/$city?T --output weather_report

# Extract current observed temperature
obs_temp=$(curl -s wttr.in/$city?T | grep -m 1 '°.' | grep -Eo -e '-?[[:digit:]].*')
echo "The current Temperature of $city: $obs_temp"

# Extract forecasted temperature for noon (local to target city)
fc_temp=$(curl -s wttr.in/$city?T | head -23 | tail -1 | grep '°.' | cut -d 'C' -f2 | grep -Eo -e '-?[[:digit:]].*')
echo "The forecasted temperature for noon tomorrow for $city: $fc_temp C"

# Log the date (based on target city's timezone)
day=$(TZ='Africa/Casablanca' date -u +%d)
month=$(TZ='Africa/Casablanca' date +%m)
year=$(TZ='Africa/Casablanca' date +%Y)

# Append a tab-delimited record to the weather log
record=$(echo -e "$year\t$month\t$day\t$obs_temp\t$fc_temp C")
echo "$record" >> rx_poc.log
