#!/bin/bash

echo "Starting script"
deployments_yaml=$(cat "PATH/deployment-prd.yml")

# Extract the namespace and deployment values using awk and grep
echo "$deployments_yaml" | awk '/- name:/ {namespace=$3} /- / && !/name:/ {print "Namespace:", namespace; print "Deployment:", $2}' | while IFS= read -r line; do
    if [[ $line == "Namespace:"* ]]; then
        namespace=$(echo "$line" | awk '{print $2}')
    elif [[ $line == "Deployment:"* ]]; then
        deployment=$(echo "$line" | awk '{print $2}')
        echo "Running hpa patch for deployment: $deployment in namespace: $namespace"
        hpa_name=$(kubectl get hpa -n "$namespace" -o=jsonpath="{range .items[?(.spec.scaleTargetRef.name==\"$deployment\")]}{.metadata.name}{\"\n\"}{end}")
        kubectl patch hpa "$hpa_name" -p '{"spec":{"minReplicas":1,"maxReplicas":1}}' -n "$namespace" 2>/dev/null || true 
    fi
done