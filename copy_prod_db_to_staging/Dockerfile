FROM alpine:3.17

RUN apk add --no-cache mongodb-tools

COPY dump_and_restore.sh /

CMD ["sh", "/dump_and_restore.sh"]
