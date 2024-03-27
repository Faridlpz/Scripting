#!/bin/bash
set -e

DATE=$(date +"%Y-%m-%d_%H-%M-%S")
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"

REGION="$3"
RESOURCE_TYPE=Secrets
RESOURCE_NAME="$1"
NAMESPACE="$2"

# functions
clear_k8s_resource() {
    #az aks command invoke --resource-group "${RG}" --name "${CLUSTER}" --command "kubectl get "${RESOURCE_TYPE}" "${RESOURCE_NAME}" -n "${NAMESPACE}" -o yaml > "./${RESOURCE_NAME}.yaml" "
    # get k8s resource
    kubectl get "${RESOURCE_TYPE}" "${RESOURCE_NAME}" -n "${NAMESPACE}" -o yaml > "./${RESOURCE_NAME}.yaml"
    # select correct sed command
    sed_command="sed"
    # remove unnecessary fields
    $sed_command -i '/creationTimestamp/d' ${RESOURCE_NAME}.yaml
    $sed_command -i '/generation/d' ${RESOURCE_NAME}.yaml
    $sed_command -i '/resourceVersion/d' ${RESOURCE_NAME}.yaml
    $sed_command -i '/uid/d' ${RESOURCE_NAME}.yaml
    $sed_command -i '/selfLink/d' ${RESOURCE_NAME}.yaml
    $sed_command -i '/annotations:/,/kubectl\.kubernetes\.io\/last-applied-configuration:/d' ${RESOURCE_NAME}.yaml
    $sed_command -i '/namespace/d' ${RESOURCE_NAME}.yaml

    # Return the content of the file
    cat ${RESOURCE_NAME}.yaml

    # Delete the file
    rm ${RESOURCE_NAME}.yaml
}

echo -e "\n==> ${RED}Backup of ${RESOURCE_TYPE} ${NC}\n"

mkdir -p backup/${REGION}-resources-bk/ && \
    cd backup/${REGION}-resources-bk/

echo -n "${RESOURCE_TYPE}: ${RESOURCE_NAME}"
# backup k8s resource
clear_k8s_resource > "./${RESOURCE_NAME}-${REGION}.yaml"
OUTPUT_FILE="${RESOURCE_NAME}-${REGION}.yaml"
cat ${RESOURCE_NAME}-${REGION}.yaml
cp ${OUTPUT_FILE} ${BUILD_ARTIFACTSTAGINGDIRECTORY}/
ls ${BUILD_ARTIFACTSTAGINGDIRECTORY}


# echo -n "Applying K8s resources"
# # install k8s resources
# kubectl -n "${NAMESPACE}" apply -f "${OUTPUT_FILE}" --recursive > /dev/null
# echo -e "\\r${CHECK_MARK} Applying K8s resources... done\n"
# echo -e "\\r${CHECK_MARK} ${RESOURCE_TYPE}: ${RESOURCE_NAME}... done\n"