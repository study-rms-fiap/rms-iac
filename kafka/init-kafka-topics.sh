#!/bin/sh

KT="/opt/bitnami/kafka/bin/kafka-topics.sh"

echo "Waiting for kafka..."
"$KT" --bootstrap-server localhost:9092 --list

echo "Creating kafka new orders"
"$KT" --bootstrap-server localhost:9092 --create --if-not-exists --topic new_orders --replication-factor 1 --partitions 1
"$KT" --bootstrap-server localhost:9092 --create --if-not-exists --topic new_orders.reply --replication-factor 1 --partitions 1

echo "Creating kafka process_payment"
"$KT" --bootstrap-server localhost:9092 --create --if-not-exists --topic process_payment --replication-factor 1 --partitions 1
"$KT" --bootstrap-server localhost:9092 --create --if-not-exists --topic process_payment.reply --replication-factor 1 --partitions 1

echo "Successfully created the following topics:"
"$KT" --bootstrap-server localhost:9092 --list