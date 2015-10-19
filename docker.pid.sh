#!/bin/bash
exec sudo docker inspect --format '{{ .State.Pid }}' "$@"