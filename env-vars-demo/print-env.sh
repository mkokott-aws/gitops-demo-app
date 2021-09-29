#!/usr/bin/env sh

while true; do
  echo "pod             - $(printenv MY_POD_NAME)"
  echo "namespace       - $(printenv MY_POD_NAMESPACE)"
  echo "service account - $(printenv MY_POD_SERVICE_ACCOUNT)"
  sleep 10;
done;


CMD [ "/bin/bash", "-c", "/create-tenant.sh" ]