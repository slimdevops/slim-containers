#!/bin/bash

docker-slim  build --target johnnyslim/slimtest:r_shiny --show-clogs  --include-path-file 'r_path_includes' --publish-port 7123 --http-probe=false
