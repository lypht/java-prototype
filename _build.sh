#!/usr/bin/env bash
set -e
. _vars.sh
docker build -t ${IMAGE} .
docker tag ${IMAGE} ${AUTHOR}/${IMAGE}:${TAG}
docker push ${AUTHOR}/${IMAGE}:${TAG}
echo "|------------------------------------------------------------"
echo "|"
echo "| [JAVA PROTOTYPE]"
echo "|"
echo "| Built and pushed: ${REGISTRY}/${AUTHOR}:${TAG}"
echo "|"
echo "|------------------------------------------------------------"
echo ""
echo ""