#!/bin/bash

LIMIT='10'
LOG_FILE="${1}"

if [[ ! -e "${LOG_FILE}" ]]
then
  echo "No es pot obrir el log file: ${LOG_FILE}" >&2
  exit 1
fi

echo 'Count,IP,Location'

grep Failed syslog-sample | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr |\
while read COUNT IP
do
  if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then
    if type -a geoiplookup >/dev/null 2>&1; then
      LOCATION=$(geoiplookup ${IP} | awk -F ',' '{print $2}')
      echo "${COUNT},${IP},${LOCATION}"
    else
      echo "${COUNT},${IP},NULL"
    fi
  fi
done
exit 0


