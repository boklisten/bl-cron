mongodump --uri="${MONGODB_URL}/production"
mongorestore --drop --uri="${MONGODB_URL}" --nsFrom="production.*" --nsTo="staging.*" dump/
