#! /bin/sh

# Put it into a folder where you wanna run and create cluster

folder="redis-7001"

if [ -d "$folder" ]; then
    echo "Folder exists."
else
    echo "Folder does not exist."
    # Three master and three slaves config
    mkdir redis-7001 redis-7002 redis-7003 redis-7004 redis-7005 redis-7006
fi


# Folders
folders=("redis-7001" "redis-7002" "redis-7003" "redis-7004" "redis-7005" "redis-7006")

# Iterate over the array using a for loop
echo "Iterating over the folders:"
for folder in "${folders[@]}"
do
    echo "Folder: $folder"
    cd $folder
    wget http://download.redis.io/redis-stable.tar.gz
    tar xzf redis-stable.tar.gz
    cd redis-stable
    make
    touch redis.conf
    # Split the string into an array
    IFS='-' read -ra parts <<< "$folder"
    first_value="${parts[1]}"
    echo $first_value

    echo "\nport $first_value \ncluster-enabled yes\ncluster-config-file nodes.conf\ncluster-node-timeout 10000\nappendonly yes" >> redis.conf
    cd ../../
done

# ONce this script is over
# Go into each folder/redis-stable -> ./src/redis-server ./redis.conf
# to create a cluster, run a command -> ./src/redis-cli --cluster create 127.0.0.1:7001 127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 127.0.0.1:7006 --cluster-replicas 1
# As we are creating 3 masters and 3 slaves, so setting replicas to 1
# to connect to redis cluster -> ./src/redis-cli -c -p 7001
# Enjoy clustering
