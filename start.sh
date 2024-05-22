#!/bin/bash

# Fail on fist error:
set -e

rm -rf exporters/ebpf_exporter || true
# Ensure the exporters directory exists
mkdir -p exporters
cd exporters

# If ebpf_exporter directory exists, pull the latest changes, otherwise clone the repo
if [ -d "ebpf_exporter" ]; then
    echo "ebpf_exporter directory already exists, pulling latest changes"
    cd ebpf_exporter
    git pull
else
    echo "Cloning ebpf_exporter repository"
    git clone https://github.com/cloudflare/ebpf_exporter.git
    cd ebpf_exporter
fi


# ebpf_exporter contains examples that need to be build locally (on the host) beforehand
# Use make to compile the code in the examples subfolder
echo "GOT HERE 1"

echo "GOT HERE 2"

make -C examples clean build

echo "GOT HERE 3"
# Build the container for ebpf_exporter (Dockerfile exists already)
# Use docker build

docker build -t ebpf_exporter .

echo "GOT HERE 4"

cd ../../

# Storage folder for Prometheus
cd prometheus
if [ -d "storage" ]; then
	echo "re-using old storage dir"
else
	mkdir storage
fi
cd ..


CURRENT_UID=$(id -u):$(id -g) docker-compose --compatibility up -d


echo "You may now open Ebpf_exporter at http://localhost:9440/metrics"
echo "You may now open Node-Exporter at http://localhost:9441/metrics"
echo "You may now open Cadvisor at http://localhost:9442/metrics"
echo "You may now open Prometheus at http://localhost:9090"
echo "You may now open Grafana at http://localhost:9091"
