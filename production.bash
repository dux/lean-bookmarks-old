#!/bin/bash

puma -e production -w 2 -t 1:16 -p 3000