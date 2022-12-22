#!/bin/sh
########## SETTINGS ###########
TAG_NAME="SH-NightFall"
CONTAINER_NAME="game-mohaa-server"
GAME_FOLDER="./files"
###############################

FULL_TAG_NAME="appelpitje/mohaa-server:$TAG_NAME"

# ! docker-compose file
cat > docker-compose.yml <<EOF
version: '3'
services:
  mohaa:
    image: $FULL_TAG_NAME
    container_name: $CONTAINER_NAME
    restart: always
    ports:
      - "12203:12203/udp"
      - "12300:12300/udp"
    volumes:
      - $GAME_FOLDER:/home/mohaa
EOF

# ! create container
docker compose create

# ! setup files
TMP_FILE="_tmp.tar"
TMP_DIR=$(mktemp -d)

mkdir "$GAME_FOLDER"

docker export "$CONTAINER_NAME" > "$TMP_FILE" # extract docker container
tar -xf "$TMP_FILE" -C "$TMP_DIR" # extract outputted tar file
mv "$TMP_DIR/home/mohaa"/* "$GAME_FOLDER" # move important content
rm -rf "$TMP_DIR" "$TMP_FILE" # clean up
