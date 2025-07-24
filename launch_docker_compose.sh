#!/usr/bin/env bash

# The application must be launched with user ID and group ID to work 
# and mount configuration files correctly

UID=$(id -u) GID=$(id -g) docker compose up -d