mongodump --uri="${MONGODB_URL}/production"
mongorestore --drop --uri="${MONGODB_URL}/staging" dump/
