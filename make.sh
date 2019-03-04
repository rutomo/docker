#!/bin/bash
set -e

if [ -f "media/.env" ]
then
  source media/.env
else
  echo ".env file does not exist. Please create one."
  exit 1
fi

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

folders=( "traefik" "portainer/data" "sabnzbd/config" "sabnzbd/downloads" "sabnzbd/incomplete" "sonarr/appdata" "sonarr/downloads" "organizr/config" "plex/config" "plex/transcode" )

for i in ${folders[@]}
do
  mkdir -p "$CONFIG_DIR/$i"
  echo $i
  # if [ "$i" == "traefik" ]
  # then
    
  # fi
done

cat > "$CONFIG_DIR/traefik/traefik.toml" <<EOL
debug = false

logLevel = "ERROR"
defaultEntryPoints = ["https","http"]

[entryPoints]
  [entryPoints.http]
  address = ":80"
    [entryPoints.http.redirect]
    entryPoint = "https"
  [entryPoints.https]
  address = ":443"
  [entryPoints.https.tls]

[retry]

[docker]
endpoint = "unix:///var/run/docker.sock"
domain = "${DOMAINNAME}"
watch = true
exposedByDefault = false

[acme]
email = "${CLOUDFLARE_EMAIL}"
storage = "acme.json"
entryPoint = "https"
#onHostRule = true
onDemand = false

[acme.dnsChallenge]
  provider = "cloudflare"
  delayBeforeCheck = 30

[[acme.domains]]
  main = "*.${DOMAINNAME}"

[[acme.domains]]
  main = "${DOMAINNAME}"

[api]
  entryPoint = "traefik"
  dashboard = true
  address = ":8080"
EOL

cd ./media
docker network create traefik_proxy
/usr/bin/docker-compose up -d
