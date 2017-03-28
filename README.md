#### Running is simple... just make sure you have the following variables defined in your variables.sh file

    CLOUDFLARE_API_KEY=736e6f6f70646f6767
    CLOUDFLARE_EMAIL=tupac@isntdead.com
    FQDN_LIST=(biggiesmalls.co www.biggiesmalls.co the.notorious.big)
    
then
    
    ./lets_encrypt.sh
    
will create (among others) the following files
* private key in `./lets-encrypt/live/${FIRST_HOSTNAME}/privkey.pem`
* certificate file in `./lets-encrypt/live/${FIRST_HOSTNAME}/fullchain.pem`

There's also some commented out code to copy the certs and restart nginx, but I'll leave that to you to decide how to implememt
