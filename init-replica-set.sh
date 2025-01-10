#!/bin/bash

echo "Waiting for MongoDB (mongodb-1:27017) to be ready..."
until mongosh --quiet --host mongodb-1 --port 27017 \
  --eval "db.runCommand({ ping: 1 }).ok" | grep 1 &>/dev/null
do
  sleep 1
done

echo "MongoDB has started successfully"

echo "Initiating MongoDB replica set..."
mongosh -u root -p root --host mongodb-1 --port 27017 --eval "
  rs.initiate({
    _id: 'rs0',
    members: [
      { _id: 0, host: 'mongodb-1:27017' }
    ]
  })
"

# echo "Initiating MongoDB replica set..."
# mongosh -u root -p root --host mongodb-1 --port 27017 --eval "
#   rs.initiate({
#     _id: 'rs0',
#     members: [
#       { _id: 0, host: 'mongodb-1:27017' },
#       { _id: 1, host: 'mongodb-2:27018' },
#       { _id: 2, host: 'mongodb-3:27019' }
#     ]
#   })
# "
