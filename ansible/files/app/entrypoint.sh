#!/bin/bash
set -e

echo "Starting Data Processor..."

# Legacy argument parsing
ARGS=("api" "--port" "5000")

exec python3 app.py "${ARGS[@]}"