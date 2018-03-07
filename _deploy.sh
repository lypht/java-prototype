#!/usr/bin/env bash
set -e
. _vars.sh



T=$(mktemp)
kubectl delete deploy ${DEPLOYMENT} -n ${NAMESPACE} || true
kubectl delete namespace heptio-contour || true
kubectl delete svc java-prototype || true
kubectl delete ing java-prototype || true
cat manifests/deployment.yaml | sed "s/REGISTRY/${REGISTRY}/g" | sed "s/IMAGE/${IMAGE}/g" | sed "s/AUTHOR/${AUTHOR}/g" | sed "s/TAG/${TAG}/g" | sed "s/DEPLOYMENT/${DEPLOYMENT}/g" > ${T}
echo "---\n" >> ${T}
cat manifests/ingress.yaml >> ${T}
echo "---\n" >> ${T}
cat manifests/service.yaml >> ${T}
echo "---\n" >> ${T}
kubectl apply -f ${T} -n ${NAMESPACE}
kubectl apply -f manifests/contour.yaml




echo "|------------------------------------------------------------"
echo "|"
echo "| [JAVA PROTOTYPE]"
echo "|"
echo "| Created Kubernetes Deployment: ${DEPLOYMENT}"
echo "| Installed Heptio Contour Ingress Controller"
echo "|"
echo "|------------------------------------------------------------"
echo ""
echo ""