#/usr/bin/env bash

rerun -d './' -p '**/*.{rb,erb,html,haml,ru,yml,md}' 'puma -p 3000 -e production'