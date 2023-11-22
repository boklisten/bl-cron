FROM alpine:3.17

RUN apk add --no-cache mongodb-tools

COPY remove_unplaced_orders.sh /

CMD ["sh", "/remove_unplaced_orders.sh"]
