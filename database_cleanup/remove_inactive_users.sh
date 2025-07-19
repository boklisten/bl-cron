# shellcheck disable=SC2016
mongosh "${MONGO_URL}" --eval '
console.log("Removing inactive users...")
const lastActivityThreshold = new Date(new Date().setFullYear(new Date().getFullYear() - 3));

const usersUpForDeletion = db.users.aggregate([
  {
    $match: {
      permission: "customer",
      lastUpdated: { $lt: lastActivityThreshold }
    }
  },
  {
    $lookup: {
      from: "userdetails",
      localField: "userDetail",
      foreignField: "_id",
      as: "userDetail"
    }
  },
  { $unwind: "$userDetail" },
  {
    $lookup: {
      from: "customeritems",
      localField: "userDetail.customerItems",
      foreignField: "_id",
      as: "customerItems"
    }
  },
  {
    $lookup: {
      from: "orders",
      localField: "userDetail.orders",
      foreignField: "_id",
      as: "orders"
    }
  },
  {
    $addFields: {
      customerItemsFiltered: {
        $filter: {
          input: "$customerItems",
          as: "item",
          cond: {
            $and: [
              { $lt: ["$$item.deadline", lastActivityThreshold] },
              { $lt: ["$$item.lastUpdated", lastActivityThreshold] },
              { $or: [
                { $eq: ["$$item.returned", true] },
                { $eq: ["$$item.cancel", true] },
                { $eq: ["$$item.buyout", true] },
                { $eq: ["$$item.buyback", true] }
              ]}
            ]
          }
        }
      },
      ordersFiltered: {
        $filter: {
          input: "$orders",
          as: "order",
          cond: { $lt: ["$$order.lastUpdated", lastActivityThreshold] }
        }
      }
    }
  },
  {
    $match: {
      $expr: {
        $and: [
          { $eq: [ { $size: "$customerItemsFiltered" }, { $size: "$customerItems" } ] },
          { $eq: [ { $size: "$ordersFiltered" }, { $size: "$orders" } ] }
        ]
      }
    }
  },
  {
    $project: {
      username: 1
    }
  }
]).toArray();
const usernames = usersUpForDeletion.map((user) => user.username);
console.log("Found ", usernames.length, " users: ", JSON.stringify(usernames))

const s1 = db.userdetails.deleteMany({email: {$in: usernames}});
console.log("db.userdetails.deleteMany() => ", s1)
const s2 = db.users.deleteMany({username: {$in: usernames}});
console.log("db.users.deleteMany() => ", s2)
'
