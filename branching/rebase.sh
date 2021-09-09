#!/bin/bash
# display command line options

count=1
for param in "$@"; do
<<<<<<< HEAD
    echo "Next parameter: $param"
>>>>>>> 90b2166 (git-rebase 2)
    count=$(( $count + 1 ))
done

echo "====="
