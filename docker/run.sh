#!/bin/bash

image="tdeheurles/tack:0"

echo " "
echo "GENERATING CLUSTER"
cd ..
#docker run -ti -v $(pwd):/cluster -v aws_cache:/root/.aws ${image} aws configure 
docker run -ti --rm -v $(pwd):/cluster -v aws_cache:/root/.aws ${image} 
