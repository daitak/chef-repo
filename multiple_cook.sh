#!/bin/sh

for node in "$@"
do
  knife solo cook $node
done
