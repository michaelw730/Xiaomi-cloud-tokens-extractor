#!/usr/bin/env bash
ha_host=$(ha network info --raw-json 2>/dev/null | jq ".data.interfaces[0].ipv4.address[0]" 2>/dev/null | sed "s/\/.*//g" 2>/dev/null | sed "s/\"//g" 2>/dev/null)
if [ -z "${ha_host}" ]; then
  ha_host="127.0.0.1"
fi
host_to_pass=$ha_host || "127.0.0.1"
set -o errexit  # fail on first error
set -o nounset  # fail on undef var
set -o pipefail # fail on first error in pipe

curl --silent --fail --show-error --location --remote-name --remote-header-name\
  https://github.com/PiotrMachowski/Xiaomi-cloud-tokens-extractor/releases/latest/download/token_extractor.zip
unzip token_extractor.zip
cd token_extractor
pip3 install -r requirements.txt
python3 token_extractor.py --host $host_to_pass
cd ..
rm -rf token_extractor token_extractor.zip
