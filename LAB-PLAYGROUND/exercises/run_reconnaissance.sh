#!/bin/bash

# bash LAB-PLAYGROUND/exercises/run_reconnaissance.sh
# bash LAB-PLAYGROUND/exercises/run_reconnaissance.sh

# Step 1 - scan network and collect running hosts
collect_running_hosts(){
  local hosts_list_filepath="LAB-PLAYGROUND/172-16-10-hosts.txt"
  local hosts=()
  while read -r line_with_host; do
    hosts+=("$(echo "$line_with_host" | awk -F'report for' '{print $2}')")
  done <<< "$(nmap -iL "$hosts_list_filepath" --open | grep "report for")"
  echo "${hosts[@]}"
}

collect_open_ports_by_host(){
  local target_host="$1"
  local scan_result
  scan_result=$(rustscan -a "$target_host" -r 1-65000 -b 1000 -g)
  local open_ports_as_str
  open_ports_as_str=$(echo "$scan_result" | awk -F'->' '{print $2}' | tr -d '[]')
  # parse '21,80' string to '21 80'
  local open_ports="${open_ports_as_str//,/ }"
  echo "$open_ports"
}

capture_host_details(){
  local target_host="$1"
  local file="$2"
  nmap -sV -O "$target_host" | grep "MAC Address:\|Running:\|OS details:" >> "$file"
}

capture_host_service_details(){
  local host="$1"
  local port="$2"
  local file="$3"

  { echo "=== PORT: $port"; printf  "\n curl results \n";  } >> "$file"

  # banner grabbing

  # curl approach
  echo -e "$host\n$port" | bash "ch04/curl_banner_grab.sh" >> "$file"

  # netcat approach
  printf  "\n netcat results \n" >> "$file"
  bash "LAB-PLAYGROUND/exercises/netcat_banner_grab_by_ip.sh" "$host" "$port" "$file"

  #webwhat approach
  printf  "\n webwhat results \n" >> "$file"
  bash "LAB-PLAYGROUND/exercises/webwhat_banner_by_ip.sh" "$host:$port" "$file"
}

mkdir -p "LAB-PLAYGROUND/scan-results"

# Step 2 - foe each host collect information and capture it in dedicated file
for host in $(collect_running_hosts); do
  echo "Creating file for $host and collecting info about it..."
  host_filename="LAB-PLAYGROUND/scan-results/${host//./-}.txt"
  touch "$host_filename"
  truncate -s 0 "$host_filename"

  echo "Host: $host" > "$host_filename"

  # Step 3 - collect full info about host (OS, MAC Address)
  capture_host_details "$host" "$host_filename"
  printf "\n" >> "$host_filename"

  # Step 4 - collect info about open ports and servers running there
  for port in $(collect_open_ports_by_host "$host"); do
    echo "Checking open port $port"
    capture_host_service_details "$host" "$port" "$host_filename"
  done
done
