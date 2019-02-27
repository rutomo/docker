#!/bin/bash
set -e

if [ -f "$PUID" ]
then
  source .env
else
  echo ".env file does not exist. Please create one."

if [ -z "$PUID" ]
then 
  echo "PUID environment variable is empty. It needs to be set prior to running this script." 
  exit 1
fi

if [ -z "$PGID" ]
then 
  echo "PGID environment variable is empty. It needs to be set prior to running this script."
  exit 1
fi

if [ -z "$TZ" ]
then
  echo "TZ environment variable is empty. It needs to be set prior to running this script."
  exit 1
fi

if [ -z "$CONFIG_DIR" ]
then 
  echo "CONFIG_DIR environment variable is empty. It needs to be set prior to running this script."
  exit 1
fi

if [ -z "$DOMAINNAME" ] 
then
  echo "DOMAINNAME environment variable is empty. It needs to be set prior to running this script."
  exit 1
fi

if [ -z "$CLOUDFLARE_EMAIL" ]
then 
  echo "CLOUDFLARE_EMAIL environment variable is empty. It needs to be set prior to running this script."
  exit 1
fi

if [ -z "$CLOUDFLARE_EMAIL" ]
then 
  echo "CLOUDFLARE_EMAIL environment variable is empty. It needs to be set prior to running this script."
  exit 1
fi

folders=( "traefik" "portainer/data" "sabnzbd/config" "sabnzbd/downloads" "sabnzbd/incomplete" "sonarr/appdata" "sonarr/downloads" )

for i in ${folders[@]}
do
  mkdir -p "$CONFIG_DIR/$i"
  echo $i
done
