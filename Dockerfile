# Build the manager binary
FROM quay.io/operator-framework/helm-operator:v1.13.0

ADD LICENSE /licenses/LICENSE

LABEL name="kong-offline-operator" \
      maintainer="harry@konghq.com" \
      vendor="Kong Inc" \
      version="v0.10.0" \
      summary="kong-operator installs and manages Kong in your k8s environemnt" \
      description="kong-operator installs and manages Kong in your k8s environemnt"

ENV HOME=/opt/helm
COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts  ${HOME}/helm-charts
WORKDIR ${HOME}
