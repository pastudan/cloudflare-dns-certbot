#!/bin/bash -e

# Run this script on a cron

mkdir -p ./lets-encrypt

source ./variables.sh
# Make sure you have the following variables in your variables.sh file
# ====================================================================
#CLOUDFLARE_API_KEY=736e6f6f70646f6767
#CLOUDFLARE_EMAIL=tupac@isntdead.com
#FQDN_LIST=(biggiesmalls.co www.biggiesmalls.co the.notorious.big)

FQDN_OPT_LIST=()
for((i=0; i<${#FQDN_LIST[@]}; i++)); do
    FQDN_OPT_LIST+=("-d ${FQDN_LIST[$i]}");
done

certbot -n \
  --config-dir ./lets-encrypt \
  --work-dir ./lets-encrypt \
  --logs-dir ./lets-encrypt \
  --manual \
  "${FQDN_OPT_LIST[@]}" \
  -m ${CLOUDFLARE_EMAIL} \
  --preferred-challenges dns \
  --agree-tos \
  --manual-public-ip-logging-ok \
  --manual-auth-hook "./lets_encrypt_auth_hook.sh" \
  certonly && {

# TODO: scp the cert into the right place and remotely reload nginx
#cp ./lets-encrypt/live/${BASE_HOSTNAME}/privkey.pem /etc/ssl/private/util.development.imgur-ops.com.key
#cp ./lets-encrypt/live/${BASE_HOSTNAME}/fullchain.pem /etc/ssl/certs/util.development.imgur-ops.com.crt
#service nginx reload

echo "Successfully created & installed cert!"

}
