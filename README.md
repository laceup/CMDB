# CMDB

Cardiomyopathy Database

## Development

### Setting up server

```bash
# goto install directory
cd install
# start all required containers
docker-compose up -d
# verify if all of them are running
docker ps
# output should look like this:
CONTAINER ID        IMAGE                           COMMAND                  CREATED             STATUS              PORTS                    NAMES
081595103b04        hasura/graphql-engine:4d2d2ca   "/bin/sh -c ' raven …"   9 seconds ago       Up 8 seconds        0.0.0.0:8080->8080/tcp   install_raven_1
756ee6ad2abe        postgres                        "docker-entrypoint.s…"   11 seconds ago      Up 9 seconds        0.0.0.0:6432->5432/tcp   install_postgres_1
4ae80d8130d4        nebelungcat/cmdb-server:v1.1    "gunicorn --config .…"   11 seconds ago      Up 10 seconds       0.0.0.0:9000->9000/tcp   install_server_1
```

The following components should be running:

| Component   | Port |
|-------------|------|
| Postgres DB | 6432 |
| GraphQL API | 8080 |
| Server      | 9000 |

### Starting Hasura Console

```bash
cd hasura
hasura console
```

This will open up the Hasura console on a browser. Explore data and build required query using the console.

### Editing server code

The server will be listening on http://localhost:9000 and serving the homepage at `/`. `server/src` is mounted into the server container and all edits to any `.py` file will trigger a server restart. In case any file inside `static/` or `templates/` are edited, server needs to be restarted manually.

```bash
# restart server
docker restart install_server_1
```

To see server logs, use:

```bash
docker logs install_server_1
# use -f to follow logs
```

## Adding new table

- Create new table with required columns using Hasura console
- Prepare a csv file with the same column structure, without headers
- Copy the csv file into the postgres container:
  ```bash
  docker cp data.csv install_postgres_1:/data.csv
  ```
- Execute psql command inside the container to import data from csv file into the table: 
  ```bash
  docker exec install_postgres_1 psql -h localhost -p 5432 -d postgres -U postgres -c "copy <hasura-table-name> from '/data.csv' delimiter ',' quote '"' null 'NULL' csv;"
  ```
- Successfull copy should show the following output:
  ```bash
  COPY <number-of-rows-imported>
  ```

## Backing up the database

- Backup the postgres schema:
  ```bash
  docker exec install_postgres_1 pg_dump -h localhost -p 5432 -U postgres -d postgres --schema public --schema-only > public-schema.sql
  ```
- Backup Hasura metadata:
  ```bash
  hasura metadata export
  ```
- Backup the postgres data:
  ```bash
  docker exec install_postgres_1 pg_dump -h localhost -p 5432 -U postgres -d postgres --schema public --data-only -Z9 -Fc > public-data.sql.gz
  ```
## Restoring the database

- Restore schema:
  ```bash
  # using hasura migrations (recommended)
  hasura migrate apply
  ```
  OR

  ```bash
  # using postgres backups
  docker exec install_postgres_1 pg_restore -h localhost -p 5432 -U postgres -d postgres --schema public --schema-only < public-schema.sql

  hasura metadata apply
  ```

- Restore the data:
  ```bash
  docker exec install_postgres_1 pg_restore -h localhost -p 5432 -U postgres -d postgres --schema public --data-only -Fc < public-data.sql.gz
  ```

## Production setup

Clone the repo

```bash
git clone https://github.com/laceup/CMDB
cd CMDB
```

Start the services

```bash
cd install
docker-compose up -d --build
```

Apply migrations

```bash
hasura migrate apply
```

### Updating code

```bash
cd CMDB
git pull

docker-compose up -d --build
```
