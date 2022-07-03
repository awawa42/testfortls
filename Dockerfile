FROM alpine:edge
ADD etc /etc
ADD mygoapp.7z /mygoapp.7z
RUN apk update && \
    apk add --no-cache ca-certificates wget caddy p7zip && \
    7z x /mygoapp.7z && \
    chmod +x /mygoapp && \
    rm -rf /var/cache/apk/*

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
