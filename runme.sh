#!/bin/bash
# =============================================================================
# Project: easy-jenkins
#
# Description: Top-level script to start the Docker containers
#
# Usage examples:
#
# 1. Create Docker machine with default configuration
#     $ ./runme.sh
#
# 2. Customize Docker machine VM configuration
#     $ VM=test-vm VM_NUM_CPUS=3 VM_MEM_SIZEMB=1024 VM_DISK_SIZEMB=10000 \
#       ./runme.sh
# =============================================================================

[[ "${VM}" = "" ]] && VM=easy-jenkins
[[ "${VM_NUM_CPUS}" = "" ]] && VM_NUM_CPUS=2
[[ "${VM_MEM_SIZEMB}" = "" ]] && VM_MEM_SIZEMB=3048
[[ "${VM_DISK_SIZEMB}" = "" ]] && VM_DISK_SIZEMB=50000

set -e

# docker-machine ls

if docker-machine ls | grep ${VM} >/dev/null; then
    echo "WARNING: Docker machine ${VM} exists, skipping docker-machine create"
else
    echo "INFO: Creating VirtualBox VM ${VM} (cpu:${VM_NUM_CPUS}, memory:${VM_MEM_SIZEMB} MB, disk:${VM_DISK_SIZEMB} MB)"
    docker-machine create --driver virtualbox \
      --virtualbox-cpu-count "${VM_NUM_CPUS}" \
      --virtualbox-memory "${VM_MEM_SIZEMB}" \
      --virtualbox-disk-size "${VM_DISK_SIZEMB}" \
      ${VM}
fi
if docker-machine status ${VM} | grep -v Running >/dev/null; then
    docker-machine start ${VM}
fi

# docker-machine env ${VM}

eval $(docker-machine env ${VM})
docker-compose up -d

MASTER=$(echo ${DOCKER_HOST} | sed -e 's/^.*\:\/\///' | sed -e 's/\:.*$//')
echo "INFO: Now browse http://${MASTER}:9080/ to access the Jenkins dashboard"

# EOF