#!/bin/bash

set -e

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"

REGION=$1
NAMESPACE=$2

echo -e "\n==> ${RED}Install K8s resources - Region: ${REGION} - Namespace: ${NAMESPACE}${NC}\n"

echo -n "Applying K8s resources"
# install k8s resources
kubectl -n "${NAMESPACE}" apply -f "jarvis/${REGION}-resources-bk" --recursive > /dev/null
echo -e "\\r${CHECK_MARK} Applying K8s resources... done\n"