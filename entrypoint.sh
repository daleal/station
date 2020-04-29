#!/bin/bash
set -e

# Activate virtual env
. /.venv/bin/activate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
./runner.sh "$@"
