#!/usr/bin/env python3

import yaml
import subprocess

# Load the YAML file
with open('deployments.yaml', 'r') as stream:
    deployments = yaml.safe_load(stream)

# Iterate over each deployment in the list
for deployment in deployments:
    deploymentName = deployment['deploymentName']
    limitsCPU = deployment['limitsCPU']
    requestsCPU = deployment['requestsCPU']
    limitsMemory = deployment['limitsMemory']
    requestsMemory = deployment['requestsMemory']

    # Print variables values from the yaml file
    print(f"Deployment: {deploymentName}")
    print(f"Limits CPU: {limitsCPU}")
    print(f"Requests CPU: {requestsCPU}")
    print(f"Limits Memory: {limitsMemory}")
    print(f"Requests Memory: {requestsMemory}")
    # Use kubect command to update our YAML configuration with new values
    #cmd = ["kubectl", "get", "pods", "-n", "test"]
    cmd = [
        "kubectl", "set", "resources", "deployment", deploymentName,
        "--limits=cpu=" + limitsCPU + ",memory=" + limitsMemory,
        "--requests=cpu=" + requestsCPU + ",memory=" + requestsMemory
    ]
    # Save the output in the variable result.
    result = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if result.returncode == 0: # if it result returns 0, it indicates that the command was succesfully executed and the changes were deployed
        print("Command succeeded. Output:")
        print(result.stdout)
    else: # Otherwise, it indicates an error
        print("Command failed. Error:")
        print(result.stderr)

    if result.returncode == 0:
        print(f"Successfully updated resources for {deploymentName}. \n")
    else:
        print(f"Failed to update resources for {deploymentName}: {result.stderr.decode('utf-8')}")