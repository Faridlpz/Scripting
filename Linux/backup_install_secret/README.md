# Kubernetes Resources Management Scripts

This document provides an overview of two scripts used for managing Kubernetes secrets. The first script is for backing up secrets, and the second one is for installing them.

## Requirements

- `kubectl` must be installed and configured to communicate with your Kubernetes cluster.
- You must have permissions to access the secrets in the specified namespace.
- The scripts must be run on a Unix-like operating system with `bash` shell.
- Ensure that the `date` command is available on your system.

## Installation

To get started, download the scripts to your local machine or clone the repository where they are stored.

```clone
git clone https://example.com/k8s-scripts-repo.git
cd k8s-scripts-repo
chmod +x backup_k8s.sh install_k8s.sh
```
## Backup Kubernetes Secrets Script

This script is intended for backing up Kubernetes secrets within a specified namespace and region.

```bash
#!/bin/bash
set -e

# Initialize color for terminal
RED='\033[0;31m'
NC='\033[0m' # No Color

# Command-line arguments
REGION="$3"
RESOURCE_NAME="$1"
NAMESPACE="$2"

# Function to clear Kubernetes secret resource
clear_k8s_resource() {
    # Extract the resource in YAML format and save to a file
    kubectl get "Secrets" "${RESOURCE_NAME}" -n "${NAMESPACE}" -o yaml > "./${RESOURCE_NAME}.yaml"
    
    # Use sed to remove metadata that is not necessary for backup
    sed -i '/creationTimestamp/d' "${RESOURCE_NAME}.yaml"
    sed -i '/generation/d' "${RESOURCE_NAME}.yaml"
    sed -i '/resourceVersion/d' "${RESOURCE_NAME}.yaml"
    sed -i '/uid/d' "${RESOURCE_NAME}.yaml"
    sed -i '/selfLink/d' "${RESOURCE_NAME}.yaml"
    sed -i '/namespace/d' "${RESOURCE_NAME}.yaml"
    sed -i '/annotations:/,/kubectl.kubernetes.io\/last-applied-configuration:/d' "${RESOURCE_NAME}.yaml"
    
    # Output and delete the resource file
    cat "${RESOURCE_NAME}.yaml"
    rm "${RESOURCE_NAME}.yaml"
}

# Create backup directories and process backup
echo -e "\n==> ${RED}Backup of Secrets resource${NC}"
mkdir -p "jarvis/${REGION}-resources-bk/" && cd "jarvis/${REGION}-resources-bk/"
echo -n "Secrets: ${RESOURCE_NAME}"
clear_k8s_resource > "./${RESOURCE_NAME}-${REGION}.yaml"
OUTPUT_FILE="${RESOURCE_NAME}-${REGION}.yaml"
cat "${OUTPUT_FILE}"
cp "${OUTPUT_FILE}" "${BUILD_ARTIFACTSTAGINGDIRECTORY}/"
ls "${BUILD_ARTIFACTSTAGINGDIRECTORY}"
```

## Install Kubernetes Secrets Script
This script will install Kubernetes secrets from a specified backup directory.

```install
#!/bin/bash
set -e

# Initialize color and checkmark for terminal output
RED='\033[0;31m'
NC='\033[0m' # No Color
CHECK_MARK="\033[0;32m\xE2\x9C\x94\033[0m"

# Command-line arguments
REGION="$1"
NAMESPACE="$2"

# Begin installation process
echo -e "\n==> ${RED}Install K8s secrets - Region: ${REGION} - Namespace: ${NAMESPACE}${NC}"
echo -n "Applying K8s secrets"
kubectl -n "${NAMESPACE}" apply -f "jarvis/${REGION}-resources-bk" --recursive > /dev/null
echo -e "\\r${CHECK_MARK} Applying K8s secrets... done"
```

## Usage
### Backup Script
To backup Kubernetes secrets, run the following command:
```execute
./backup_k8s.sh <RESOURCE_NAME> <NAMESPACE> <REGION>
```