# Deployment Scaling Script

## Overview
This README outlines the purpose and functionality of a bash script designed to scale Kubernetes Horizontal Pod Autoscalers (HPAs) in a production environment. The script is intended for use as part of continuous deployment or system administration procedures.

## Script Description

The script `scale_deployments_hpa.sh` is a bash script that processes a YAML file containing a list of namespaces and deployments, and scales their associated HPAs to a minimum and maximum of 1 replica. This is generally useful when preparing for a controlled deployment or maintaining a low resource footprint.

### How the Script Works

Upon execution, the script performs the following actions:

1. Outputs a starting message to indicate the beginning of the script execution.
2. Reads in the deployment configuration from a YAML file located at `PATH/deployment-prd.yml`.
3. Extracts the namespace and deployment names from the YAML file.
4. Loops through each deployment and uses `kubectl` to identify and patch the corresponding HPA, setting its minimum and maximum replicas to 1.

### YAML File Format

The YAML file parsed by this script should be in the following format:

```yaml
- name: namespaceName
  deployments:
    - deploymentName
- name: namespaceName
  deployments:
    - deploymentName
```

## Prerequisites
To use this script, you should have the following set up in your environment:

- Kubernetes command-line tool (kubectl) configured to communicate with your cluster
- Bash shell environment

## Usage
Ensure the script is executable:

```permissions
chmod +x scale_deployments.sh
```

Run the script:

```script
./scale_deployments.sh
```

Observe the script output to verify the HPAs have been patched successfully.