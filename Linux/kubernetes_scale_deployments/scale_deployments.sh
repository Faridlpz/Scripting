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