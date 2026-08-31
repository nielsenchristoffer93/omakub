#!/bin/bash

# Install default databases
if [[ -v OMAKUB_FIRST_RUN_DBS ]]; then
	dbs=$OMAKUB_FIRST_RUN_DBS
else
	AVAILABLE_DBS=("MySQL" "Redis" "PostgreSQL")
	dbs=$(gum choose "${AVAILABLE_DBS[@]}" --no-limit --height 5 --header "Select databases (runs in Docker)")
fi

if [[ -n "$dbs" ]]; then
	for db in $dbs; do
		case $db in
		MySQL)
			if sudo docker ps --format '{{.Names}}' | grep -Eq '^(mysql|mysql8)$'; then
				echo "MySQL container is already running."
			elif sudo docker ps -a --format '{{.Names}}' | grep -Eq '^(mysql|mysql8)$'; then
				echo "Starting existing MySQL container..."
				existing_container=$(sudo docker ps -a --format '{{.Names}}' | grep -E '^(mysql|mysql8)$' | head -n 1)
				sudo docker start "$existing_container"
			elif sudo docker ps --filter "publish=3306" --format '{{.Names}}' | grep -q .; then
				occupant=$(sudo docker ps --filter "publish=3306" --format '{{.Names}}')
				echo "Warning: Port 3306 is already in use by container '$occupant'. Skipping new container to prevent data loss."
			elif ss -tuln | grep -q ':3306 '; then
				echo "Warning: Port 3306 is already in use by another service on the host. Skipping Docker container."
			else
				sudo docker run -d --restart unless-stopped -p "127.0.0.1:3306:3306" -v mysql-data:/var/lib/mysql --name=mysql -e MYSQL_ROOT_PASSWORD= -e MYSQL_ALLOW_EMPTY_PASSWORD=true mysql:latest
			fi
			;;
		Redis)
			if sudo docker ps --format '{{.Names}}' | grep -Eq '^redis$'; then
				echo "Redis container is already running."
			elif sudo docker ps -a --format '{{.Names}}' | grep -Eq '^redis$'; then
				echo "Starting existing Redis container..."
				sudo docker start redis
			elif sudo docker ps --filter "publish=6379" --format '{{.Names}}' | grep -q .; then
				occupant=$(sudo docker ps --filter "publish=6379" --format '{{.Names}}')
				echo "Warning: Port 6379 is already in use by container '$occupant'. Skipping new container to prevent data loss."
			elif ss -tuln | grep -q ':6379 '; then
				echo "Warning: Port 6379 is already in use by another service on the host. Skipping Docker container."
			else
				sudo docker run -d --restart unless-stopped -p "127.0.0.1:6379:6379" -v redis-data:/data --name=redis redis:latest
			fi
			;;
		PostgreSQL)
			if sudo docker ps --format '{{.Names}}' | grep -Eq '^(postgres|postgres16)$'; then
				echo "PostgreSQL container is already running."
			elif sudo docker ps -a --format '{{.Names}}' | grep -Eq '^(postgres|postgres16)$'; then
				echo "Starting existing PostgreSQL container..."
				existing_container=$(sudo docker ps -a --format '{{.Names}}' | grep -E '^(postgres|postgres16)$' | head -n 1)
				sudo docker start "$existing_container"
			elif sudo docker ps --filter "publish=5432" --format '{{.Names}}' | grep -q .; then
				occupant=$(sudo docker ps --filter "publish=5432" --format '{{.Names}}')
				echo "Warning: Port 5432 is already in use by container '$occupant'. Skipping new container to prevent data loss."
			elif ss -tuln | grep -q ':5432 '; then
				echo "Warning: Port 5432 is already in use by another service on the host. Skipping Docker container."
			else
				sudo docker run -d --restart unless-stopped -p "127.0.0.1:5432:5432" -v postgres-data:/var/lib/postgresql/data --name=postgres -e POSTGRES_HOST_AUTH_METHOD=trust postgres:latest
			fi
			;;
		esac
	done
fi
