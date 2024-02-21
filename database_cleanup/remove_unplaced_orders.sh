mongosh "${MONGO_URL}" --eval '
console.log("Removing unplaced orders...")
db.orders.deleteMany({
  placed: false,
  lastUpdated: {
    $lt: new Date(
      new Date().setFullYear(
        new Date().getFullYear() - 1
      )
    )
  }
})'
