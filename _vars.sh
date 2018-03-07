#!/usr/bin/env bash
set -e



REGISTRY=${REGISTRY:-registry.hub.docker.com}
IMAGE=${IMAGE:-java-prototype}
AUTHOR=${AUTHOR:-java-prototype-user}
COMMIT_MSG=${COMMIT_MSG:-java-prototype-commit}
REPOSITORY=${REPOSITORY:-java-prototype}
TAG=${TAG:-latest}

DEPLOYMENT=${DEPLOYMENT:-java-prototype}
NAMESPACE=${NAMESPACE:-default}

echo "|------------------------------------------------------------"
echo "|"
echo "| [JAVA PROTOTYPE]"
echo "|"
echo "|"
echo "| REGISTRY:    ${REGISTRY}"
echo "| IMAGE:       ${IMAGE}"
echo "| AUTHOR:      ${AUTHOR}"
echo "| COMMIT MSG:  ${COMMIT_MSG}"
echo "| REPOSITORY:  ${REPOSITORY}"
echo "| TAG:         ${TAG}"
echo "| DEPLOYMENT:  ${DEPLOYMENT}"
echo "| NAMESPACE:   ${NAMESPACE}"
echo "|"
echo "|------------------------------------------------------------"
echo ""
echo ""