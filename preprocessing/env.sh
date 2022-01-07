#!/bin/bash

# Usage: source ./env.sh

# Loads custom software to PATH

dir=$(realpath $(dirname "$BASH_SOURCE"))
PATH="$dir/software/Bismark-0.21.0":"$dir/software/BSseeker2-BSseeker2-v2.1.8":$PATH
