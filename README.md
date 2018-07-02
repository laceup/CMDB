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
