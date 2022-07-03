#!/bin/sh

test -z "$AUUID" && AUUID="4bc947b4-f509-4192-8b70-628eda7c7d9d"
test -z "$CADDYIndexPage" && CADDYIndexPage="https://github.com/wulabing/3DCEList/archive/master.zip"

# configs
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
cat /etc/Caddyfile | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
cat /etc/mygoapp.json | sed -e "s/\$AUUID/$AUUID/g" >/mygoapp.json



# storefiles
mkdir -p "/usr/share/caddy/$AUUID"
cp /mygoapp.7z "/usr/share/caddy/$AUUID"
cp /mygoapp.json "/usr/share/caddy/$AUUID"
cp /etc/caddy/Caddyfile "/usr/share/caddy/$AUUID"

# start

cat /mygoapp.json
/mygoapp -config /mygoapp.json &
cat /etc/caddy/Caddyfile
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
