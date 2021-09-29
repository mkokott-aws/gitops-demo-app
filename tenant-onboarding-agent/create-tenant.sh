#!/bin/bash

if [ -z "${TENANT_ID}" ] || [ -z "${APP_REPO_URL}" ] || [ -z "${APP_REPO_BRANCH}" ] || [ -z "${APP_REPO_MANIFEST_PATH}" ] || [ -z "${CLUSTER_CONFIG_REPO}" ] || [ -z "${CLUSTER_CONFIG_BRANCH}" ] || [ -z "${CLUSTER_CONFIG_PATH}" ] || [ -z "${GITHUB_TOKEN}" ]; then
  echo "mandatory variables not initialized"
  exit 1
fi

git clone "https://${GITHUB_TOKEN}:x-oauth-basic@github.com/${CLUSTER_CONFIG_REPO}" --branch ${CLUSTER_CONFIG_BRANCH} --single-branch cluster-config 
if [ -d cluster-config/${CLUSTER_CONFIG_PATH}/${TENANT_ID} ]; then
  echo "tenant ${TENANT_ID} already exists in ${CLUSTER_CONFIG_PATH} of ${CLUSTER_CONFIG_REPO} for branch ${CLUSTER_CONFIG_BRANCH}"
  exit 1
fi

mkdir -p cluster-config/${CLUSTER_CONFIG_PATH}/${TENANT_ID} && cd cluster-config/${CLUSTER_CONFIG_PATH}/${TENANT_ID}
flux create tenant ${TENANT_ID} --with-namespace=${TENANT_ID} --export > rbac.yaml
flux create source git ${TENANT_ID} --namespace=${TENANT_ID} --url=${APP_REPO_URL} --branch=${APP_REPO_BRANCH} --export > sync.yaml
flux create kustomization ${TENANT_ID} --namespace=${TENANT_ID} --service-account=${TENANT_ID} --target-namespace=${TENANT_ID} --source=GitRepository/${TENANT_ID} --path=${APP_REPO_MANIFEST_PATH} --export >> sync.yaml
kustomize create --autodetect
git add -A
git commit -m "created tenant ${TENANT_ID}"
git pull --rebase && git push
