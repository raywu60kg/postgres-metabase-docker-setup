TAG = 0.1.0
postgres-build:
	docker build -f ./postgres/dockerfile -t raywu60kg/postgres:${TAG} .

postgres-up:
	docker run -d \
        --rm \
	    --name postgres \
		--network=host \
		-p 5432:5432 \
	    raywu60kg/postgres:${TAG}

# postgres-up:
# 	docker run -d \
#         --rm \
# 	    --name postgres \
# 		-p 5432:5432 \
# 	    -v /opt/postgres:/var/lib/postgres/data \
# 	    raywu60kg/postgres:${TAG}

postgres-exec:
	docker exec -it postgres psql -U raywu world

postgres-load-world-data:
	docker exec -it postgres psql -U raywu world -f /data/World.sql

postgres-load-metabase-data:
	docker exec -it postgres psql -U raywu metabase -f /data/Metabase.sql

metabase-up:
	docker run -d -p 3000:3000 \
		-e "MB_DB_TYPE=postgres" \
		-e "MB_DB_DBNAME=metabase" \
		-e "MB_DB_PORT=5432" \
		-e "MB_DB_USER=raywu" \
		-e "MB_DB_PASS=raywu60kg" \
		-e "MB_DB_HOST=localhost" \
		--network=host \
		--name metabase metabase/metabase:v0.37.9
