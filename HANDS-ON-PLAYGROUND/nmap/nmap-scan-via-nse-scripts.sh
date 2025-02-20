#!/usr/bin/env bash

# How to use:
# bash TEMPO/nmap/nmap-scan-via-nse-scripts.sh "194.54.81.46" "443" "http"
# bash TEMPO/nmap/nmap-scan-via-nse-scripts.sh "194.54.81.46" "22" "ssh"
# bash TEMPO/nmap/nmap-scan-via-nse-scripts.sh "194.54.81.46" "21" "ftp"
# bash TEMPO/nmap/nmap-scan-via-nse-scripts.sh "172.16.10.13" "22" "ssh"
# bash TEMPO/nmap/nmap-scan-via-nse-scripts.sh "172.16.10.13" "53" "smtp"
# bash TEMPO/nmap/nmap-scan-via-nse-scripts.sh "172.16.10.10" "8081" "http"
# bash TEMPO/nmap/nmap-scan-via-nse-scripts.sh "172.16.10.11" "80" "http"

# NSE scripts:
# ls -al /usr/share/nmap/scripts | grep http
# ls -al /usr/share/nmap/scripts | grep ssh

TARGET_IP_ADDRESS=$1
TARGET_PORTS=$2
NSE_KEYWORD=$3
OUTPUT_DIR="/tmp/nmap-scans"

# Specify delay to be 'stealthy'
DELAY=1
read -r -p "Delay (default=$DELAY): " provided_delay
if [[ "$provided_delay" =~ ^[0-9]+$ ]] && [[ "$provided_delay" -gt "$DELAY" ]]; then
  DELAY=$provided_delay
  echo "Overridden delay: ${DELAY} sec"
else
  echo "Defaulted delay: ${DELAY} sec"
fi

mkdir -p "$OUTPUT_DIR"

compose_file_name() {
  local ip_hyphens=$(echo "$TARGET_IP_ADDRESS" | tr '.' '-')
  local filename="$OUTPUT_DIR/${ip_hyphens}-${NSE_KEYWORD}.txt"
  echo "$filename"
}

extract_results() {
  # pay attention to exclusions (grep -v);
  echo "$1" \
    | grep "^|" \
    | grep -v "robtex" \
    | sed 's/^/   /'
}

output_file=$(compose_file_name)
rm -rf "$output_file"; touch "$output_file"

echo "$TARGET_IP_ADDRESS ($TARGET_PORTS) > NSE Keyword = $NSE_KEYWORD" | tee -a "$output_file"
echo "-----" | tee -a "$output_file"

while read -r script_name; do
  # Static exclusions
  if [[ "$script_name" =~ "robtex" || "$script_name" =~ "brute" ]]; then
    echo "[X] $script_name.nse (force skipped)" | tee -a "$output_file"
    continue
  fi

  raw_scan_results=$(timeout 20 nmap --script="$script_name" "$TARGET_IP_ADDRESS" -p "$TARGET_PORTS" 2> /dev/null)
  scan_results=$(extract_results "$raw_scan_results")

  if echo "$scan_results" | grep -q "|"; then
    echo "[Y] $script_name.nse" | tee -a "$output_file"
    echo "$scan_results" | tee -a "$output_file"
  else
    echo "[ ] $script_name.nse" | tee -a "$output_file"
  fi

  # sleep after each scan
  sleep "$DELAY"
done < <(ls /usr/share/nmap/scripts | grep "$NSE_KEYWORD" | sed 's/.nse//g')

echo "Output file: $output_file"