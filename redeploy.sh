#!/bin/bash
set -xe

export UNI_ROOT=$(pwd)

SERVICE_NAME="$1"
TARGET_ENV="$2"
REDEPLOY_INGRESS="$3"
REDEPLOY_CONFIGMAP="$4"
REDEPLOY_TAG="$5"

export SERVICE_HOME=${UNI_ROOT}/service-scripts/${SERVICE_NAME}

if [ "$TARGET_ENV" = 'dev-hainan' ]; then
export KUBECONFIG="/etc/kubectl/config/dev"
else
export KUBECONFIG="/etc/kubectl/config/$TARGET_ENV"
echo "KUBECONFIG: $KUBECONFIG"
fi

if [ ! -f ${SERVICE_HOME}/redeploy.sh ]; then
echo "${SERVICE_HOME}/redeploy.sh not exist"
exit 1
else
sh ${SERVICE_HOME}/redeploy.sh ${TARGET_ENV} ${REDEPLOY_CONFIGMAP} ${REDEPLOY_TAG}
fi


if [ ${REDEPLOY_INGRESS} == "YES" ] && [ -f ${SERVICE_HOME}/${TARGET_ENV}-ingress.yaml ]; then
k3s kubectl apply -f ${SERVICE_HOME}/${TARGET_ENV}-ingress.yaml
fi