#!/usr/bin/env bash

# In case you want to change some attributes of the JWT token, please check the docs and adjust the proper files accordingly
#   REF: https://docs.tetrate.io/service-bridge/1.6.x/en-us/setup/workload_onboarding/quickstart/on-premise/configure-workload-onboarding#allow-workloads-to-authenticate-themselves-by-means-of-a-jwt-token
#   REF: https://github.com/tet./onboarding-agent-sample-jwt-credential-plugin --docsrateio/onboarding-agent-sample-jwt-credential-plugin

if ! [[ -f "onboarding-agent-sample-jwt-credential-plugin" ]]; then
  curl -fL "https://dl.cloudsmith.io/public/tetrate/onboarding-examples/raw/files/onboarding-agent-sample-jwt-credential-plugin_0.0.1_$(uname -s)_$(uname -m).tar.gz" \
    | tar -xz onboarding-agent-sample-jwt-credential-plugin
fi

export SAMPLE_JWT_ISSUER="https://issuer-a.tetrate.prod"
export SAMPLE_JWT_SUBJECT="ubuntu-vm-a.tetrate.prod"
export SAMPLE_JWT_ATTRIBUTES_FIELD="custom_attributes"
export SAMPLE_JWT_ATTRIBUTES="instance_name=ubuntu-vm-a,instance_role=app-a,region=region1"
export SAMPLE_JWT_EXPIRATION="87600h"

./onboarding-agent-sample-jwt-credential-plugin generate key -o ./04-ubuntu-vm-a/sample-jwt-issuer

export SAMPLE_JWT_ISSUER="https://issuer-b.tetrate.prod"
export SAMPLE_JWT_SUBJECT="ubuntu-vm-b.tetrate.prod"
export SAMPLE_JWT_ATTRIBUTES_FIELD="custom_attributes"
export SAMPLE_JWT_ATTRIBUTES="instance_name=ubuntu-vm-b,instance_role=app-b,region=region1"
export SAMPLE_JWT_EXPIRATION="87600h"

./onboarding-agent-sample-jwt-credential-plugin generate key -o ./05-ubuntu-vm-b/sample-jwt-issuer

export SAMPLE_JWT_ISSUER="https://issuer-c.tetrate.prod"
export SAMPLE_JWT_SUBJECT="ubuntu-vm-c.tetrate.prod"
export SAMPLE_JWT_ATTRIBUTES_FIELD="custom_attributes"
export SAMPLE_JWT_ATTRIBUTES="instance_name=ubuntu-vm-c,instance_role=app-c,region=region1"
export SAMPLE_JWT_EXPIRATION="87600h"

./onboarding-agent-sample-jwt-credential-plugin generate key -o ./06-ubuntu-vm-c/sample-jwt-issuer

export JWKS_VM_A=$(cat ./04-ubuntu-vm-a/sample-jwt-issuer.jwks | tr '\n' ' ' | tr -d ' ')
export JWKS_VM_B=$(cat ./05-ubuntu-vm-b/sample-jwt-issuer.jwks | tr '\n' ' ' | tr -d ' ')
export JWKS_VM_C=$(cat ./06-ubuntu-vm-c/sample-jwt-issuer.jwks | tr '\n' ' ' | tr -d ' ')
envsubst < ./02-active-cluster/onboarding-vm-patch-template.yaml > ./02-active-cluster/onboarding-vm-patch.yaml