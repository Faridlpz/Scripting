# Kubernetes Deployment Scaler Script

## Overview
This document provides an explanation for a Bash script designed to scale Kubernetes deployments found in a specified YAML file to zero replicas. The script identifies deployments within each namespace listed in the YAML file and scales them down, effectively pausing the deployment's pods.

## Script Explanation

```bash
echo "Starting script"
deployments_yaml=$(cat "PATH/deployments-prd.yml")

# Extract the namespace and deployment values using awk and grep
echo "$deployments_yaml" | awk '/- name:/ {namespace=$3} /- / && !/name:/ {print "Namespace:", namespace; print "Deployment:", $2}' | while IFS= read -r line; do
if [[ $line == "Namespace:"* ]]; then
    namespace=$(echo "$line" | awk '{print $2}')
elif [[ $line == "Deployment:"* ]]; then
    deployment=$(echo "$line" | awk '{print $2}')
    echo "Running scale for deployment: $deployment in namespace: $namespace"
    kubectl scale Deployment/"$deployment" --replicas=0 -n "$namespace"
fi
done
```

### Breakdown of the Script
- Start Message: The script outputs a message indicating it has started.

- Read YAML File: It reads the contents of a specified YAML file, which should be located at PATH/deployments-prd.yml. Replace PATH with the actual path to your YAML file.

- Parse YAML Content: Using awk, the script parses the deployments_yaml variable's contents to locate each namespace and its deployments.

- Processing Loop: For each namespace-deployment pair found in the YAML content, the script performs the following:

- Checks if the line contains a namespace or deployment.
Extracts the namespace or deployment value.
Runs the kubectl scale command to scale the identified deployment to zero replicas in its associated namespace.

### Usage

To use the script:

Replace PATH in the script with the actual path to your YAML file.
Ensure kubectl is configured correctly to interact with your Kubernetes cluster.
Execute the script. It will scale down the listed deployments to zero replicas.