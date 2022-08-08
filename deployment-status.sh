if ! kubectl get ns leo-schaffner; then
    kubectl create ns leo-schaffner
fi

if ! kubectl rollout status deployment sample-spring-boot -n leo-schaffner; then
    kubectl apply -f kubernetes.yml -n leo-schaffner
fi