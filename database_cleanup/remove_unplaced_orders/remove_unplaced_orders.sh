mongo "${MONGO_URL}/production" --eval 'db.orders.remove({ placed: false, creationTime: {$lt: new Date(new Date().setFullYear(new Date().getFullYear() - 1))}})'
