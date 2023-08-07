#!/bin/bash

set -eu

./build.sh && http-server
