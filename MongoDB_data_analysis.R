install.packages("tidyverse")
install.packages("ggplot2")
install.packages("mongolite")
library(mongolite)
library(tidyverse)
library(ggplot2)

connection_string = "mongodb+srv://nvkanirudh:Anirudh124@cluster0.hr7x8jg.mongodb.net/sample_analytics"
accounts_collection = mongo(collection="accounts", db="sample_analytics", url=connection_string)
customers_collection = mongo(collection="customers", db="sample_analytics", url=connection_string)
transactions_collection = mongo(collection="transactions", db="sample_analytics", url=connection_string)

# Counting the number of documents in each of the collections
accounts_collection$count()
customers_collection$count()
transactions_collection$count()

# Examining the structure of data in these collections
accounts_collection$iterate()$one()
customers_collection$iterate()$one()
transactions_collection$iterate()$one()

############################################### Analysis on accounts collection ###############################################

# Checking the uniqueness of account ids
query = accounts_collection$distinct("account_id")
length(query)

# Finding length of products for each account
product_count = accounts_collection$aggregate('[
  {
    "$project": {
      "account_id": 1,
      "products": { "$cond": { "if": {"$isArray": "$products"}, "then": {"$size": "$products"}, "else": "NA"}}
    }
  }
]')

# Checking the result of above query
product_count

# Histogram of product counts
df <- as.data.frame(product_count)
ggplot(df, aes(x=products)) + geom_histogram(fill="light pink")

############################################### Analysis on customers collection ###############################################

# Counting number of accounts each customer has
customers_collection$iterate()$one()
account_count = customers_collection$aggregate('[
  {
    "$project": {
      "_id": 0,
      "username": 1,
      "name": 1,
      "address": 1,
      "birthdate": 1,
      "email": 1,
      "account_count": { "$cond": { "if": {"$isArray": "$accounts"}, "then": {"$size": "$accounts"}, "else": "NA"}}
    }
  }
]')

# Checking the result of above query
account_count

# Histogram of account counts
df <- as.data.frame(account_count)
ggplot(df, aes(x=account_count)) + geom_histogram(fill="light pink")

# Counting number of tiers each customer has
tier_count = customers_collection$aggregate('[
  {
    "$project": {
      "_id": 0,
      "username": 1,
      "name": 1,
      "address": 1,
      "birthdate": 1,
      "email": 1,
      "tier_count": {"$size": {"$objectToArray": "$tier_and_details"}}
    }
  }
]')

# Checking the result of above query
tier_count

# Histogram of account counts
df <- as.data.frame(tier_count)
ggplot(df, aes(x=tier_count)) + geom_histogram(fill="light pink")

############################################### Analysis on transactions collection ###############################################

# Histogram of transaction counts
transactions_counts = transactions_collection$find(fields = '{"_id": false, "transaction_count": true}')

df <- as.data.frame(transactions_counts)
ggplot(df, aes(x=transaction_count)) + geom_histogram(fill="light pink")


# Number of transactions per symbol along with visualization
transactions_per_symbol = transactions_collection$aggregate('[
  {
    "$unwind": "$transactions"
  },
  {
    "$group": {"_id":"$transactions.symbol", "symbol": {"$first":"$transactions.symbol"}, "Count": {"$sum": 1}}
  }
]')

# Checking the result of above query
transactions_per_symbol

df <- as.data.frame(transactions_per_symbol)
ggplot(data=df, aes(x=symbol, y=Count)) + geom_bar(stat="identity", fill="light pink")

# Number of transactions made per symbol and per transaction_code
transactions_per_symbol_and_code = transactions_collection$aggregate('[
  {
    "$unwind": "$transactions"
  },
  {
    "$group": {"_id":{"Symbol": "$transactions.symbol","Code": "$transactions.transaction_code"}, 
    "symbol": {"$first":"$transactions.symbol"}, 
    "code": {"$first":"$transactions.transaction_code"},
    "Count": {"$sum": 1}}
  }
]')

# Checking the result of above query
transactions_per_symbol_and_code

df <- as.data.frame(transactions_per_symbol_and_code)
ggplot(df, aes(x=symbol, y=Count, fill=code, color=code)) +
  geom_bar(stat="identity", position="dodge")

# Max and Min of total per symbol and per transaction code
max_min_total_per_symbol_code = transactions_collection$aggregate('[
  {
    "$unwind": "$transactions"
  },
  {
    "$group": {"_id": {"Symbol": "$transactions.symbol","Code": "$transactions.transaction_code"},
    "symbol": {"$first":"$transactions.symbol"}, "code": {"$first":"$transactions.transaction_code"},
    "maxTotal": {"$max": "$transactions.total"},
    "minTotal": {"$min": "$transactions.total"}
    }
  }
]')

# Checking the result of above query
max_min_total_per_symbol_code

# Maximum total plot
df <- as.data.frame(max_min_total_per_symbol_code)
ggplot(df, aes(x=symbol, y=maxTotal, fill=code, color=code)) +
  geom_bar(stat="identity", position="dodge")

# Minimum total plot
df <- as.data.frame(max_min_total_per_symbol_code)
ggplot(df, aes(x=symbol, y=minTotal, fill=code, color=code)) +
  geom_bar(stat="identity", position="dodge")


# Below analysis is irrelevant for this data but a very good analysis aspect
# Maximum total for each symbol and their count (number of min total per symbol)
# max_total = transactions_collection$aggregate('[
#   {
#     "$unwind": "$transactions"
#   },
#   {
#     "$group": {"_id": "$transactions.symbol", "maxTotal": {"$max": "$transactions.total"}, 
#     "Totals": {"$push": "$transactions.total"}}
#   },
#   {
#     "$unwind": "$Totals"
#   },
#   {
#     "$match": {
#       "$expr": {
#         "$eq": ["$Totals", "$maxTotal"]
#       }
#     }                                            
#   },
#   {
#     "$group": {
#       "_id": "$_id",
#       "maxTotal": {
#         "$max": "$maxTotal"
#       },
#       "Count": {
#         "$sum": 1
#       }
#     }                                            
#   }
# ]')
# max_total
















