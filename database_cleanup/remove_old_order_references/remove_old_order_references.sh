mongo "${MONGO_URL}/production" --eval '
db.userdetails.aggregate([
    {
        $lookup: {
            from: "orders",
            localField: "orders",
            foreignField: "_id",
            as: "matched_orders"
        }
    },
    {
        $addFields: {
            orders: {
                $filter: {
                    input: "$orders",
                    as: "order",
                    cond: { $in: ["$$order", "$matched_orders._id"] }
                }
            }
        }
    },
    {
       $project: {
           matched_orders: 0,
       }
    },
    {
        $merge: {
            into: "userdetails",
            whenMatched: "replace"
        }
    }
])
'
