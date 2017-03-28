#!/bin/bash -e

source ./variables.sh

# We log to stderr in this script because otherwise no output is shown / logged when running certbot
# It's a known certbot behavior / bug: https://github.com/certbot/certbot/issues/4167

DOMAIN_PIECES=(${CERTBOT_DOMAIN//\./ }) #replace . with space, and parse resulting pieces as array
SECOND_LEVEL_DOMAIN=$(echo ${DOMAIN_PIECES[@]: -2} | sed "s/ /\./") # get just second level domain

>&2 echo "Fetching Zone ID from CloudFlare"
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=${SECOND_LEVEL_DOMAIN}" \
    -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
    -H "X-Auth-Key: ${CLOUDFLARE_API_KEY}" \
    -H "Content-Type: application/json" | jq --raw-output .result[0].id 2>&1)

>&2 echo "Setting certbot TXT challenge record"
curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records" \
    -H "X-Auth-Email: ${CLOUDFLARE_EMAIL}" \
    -H "X-Auth-Key: ${CLOUDFLARE_API_KEY}" \
    -H "Content-Type: application/json" \
    --data '{"type":"TXT","name":"_acme-challenge.'${CERTBOT_DOMAIN}'","content":"'${CERTBOT_VALIDATION}'"}' 2>&1

if [ "${CERTBOT_DOMAIN}" == "${FQDN_LIST[@]: -1}" ]; then
    # if this is the last FQDN, then allow time for the changes to propagate
    >&2 echo "Waiting 5 seconds for changes to propagate..."
    sleep 5
fi
