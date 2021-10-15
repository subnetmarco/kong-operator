FROM quay.io/operator-framework/helm-operator:v0.19.4

ADD LICENSE /licenses/LICENSE

LABEL name="kong-operator" \
      maintainer="harry@konghq.com" \
      vendor="Kong Inc" \
      version="v0.9.1" \
      summary="kong-operator installs and manages Kong in your k8s environemnt" \
      description="kong-operator installs and manages Kong in your k8s environemnt"

RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical

COPY watches.yaml ${HOME}/watches.yaml
COPY helm-charts/ ${HOME}/helm-charts/
