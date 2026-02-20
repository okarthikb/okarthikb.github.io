#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./update.sh \"Post Title\""
  exit 1
fi

./new-post.sh "$1"
