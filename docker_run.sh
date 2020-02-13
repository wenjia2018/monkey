#!/bin/bash/

docker run -it \
     -e PASSWORD=bioc \
     -p 8787:8787  -v /Volumes/Share/projects/monkey:/home/rstudio/workspace \
     -v /Volumes/Share/preprocessed:/home/rstudio/workspace/data/preprocessed \
     -v /Volumes/share/projects/cell_type_cibersort:/home/rstudio/workspace/data/cell_type_cybersort \
     chumbleycode/monkey:0.0.19  bash
