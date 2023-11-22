FROM alpine:3.17

RUN apk add --no-cache mongodb-tools

COPY remove_old_order_references.sh /

CMD ["sh", "/remove_old_order_references.sh"]
