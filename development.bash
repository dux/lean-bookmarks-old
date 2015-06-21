#/usr/bin/env bash

# rerun -d './' -p '**/*.{rb,ru,yml,md}' 'puma -p 3000 -e production'
rerun -d './' -p '**/*.{rb,ru,yml}' 'puma -p 3000'


