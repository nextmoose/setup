FROM docker:18.05.0-ce
RUN apk update && apk upgrade && apk add --no-cache util-linux && rm -rf /var/cache/apk/*
COPY root /opt/
ENTRYPOINT ["sh", "/opt/scripts/entrypoint.sh"]
CMD []
