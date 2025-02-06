#!/usr/bin/env bash

fswatch -o ./*.json* | while read -r; do ./build.sh; done

