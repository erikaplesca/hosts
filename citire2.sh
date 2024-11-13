#!/bin/bash

check_ip() {
  local hostname="$1"
  local ip="$2"
  local dns_server="$3"
  local nslookup_ip

  nslookup_ip=$(nslookup "$hostname" "$dns_server" | grep 'Address' | tail -n 1 | awk '{print $2}')

  if [[ "$ip" != "$nslookup_ip" ]]; then
    echo "Bogus IP for $hostname in /etc/hosts!"
  fi
}

DNS_SERVER="8.8.8.8"

cat /etc/hosts | while read -r line; do
  ip=$(echo "$line" | awk '{print $1}')
  hostname=$(echo "$line" | awk '{print $2}')

  check_ip "$hostname" "$ip" "$DNS_SERVER"
done
