#!/usr/bin/env bash

fswatch -o template.json | while read -r; do ./build.sh; done

