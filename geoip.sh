#!/bin/bash
if [[ $EUID -ne 0 ]]; then
	   echo "This script must be run as root"
	      exit 1
      fi
      file="$1"
      date=$(cat $file | awk '{print $4}' | awk 'NR==1; END{print}' | tr -d [)
      echo "Logs Parsed from $date"
      cat $file | awk '{print $1}' | sort -n | uniq -c | sort -nr | head -20 > ip.txt
      input=ip.txt
      while IFS= read -r var
      do
	        IP=$(echo $var | awk '{print $2}')
		  COUNT=$(echo $var | awk '{print $1}')
		    INFO=$(curl -s http://ip-api.com/json/$IP | jq .isp,.countryCode | sed ':a;N;$!ba;s/\n/+/g')
		      echo "$COUNT $IP $INFO"
	      done < "$input"
