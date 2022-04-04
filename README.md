# Kong Operator
[![][kong-logo]][kong-url]

![Test status badge](https://github.com/Kong/kong-operator/workflows/Test/badge.svg)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/Kong/kong-operator/blob/main/LICENSE)
[![Twitter](https://img.shields.io/twitter/follow/thekonginc.svg?style=social&label=Follow)](https://twitter.com/intent/follow?screen_name=thekonginc)

---

**Use of this operator for new Kong installations is discouraged in favor of the [kubectl](https://docs.konghq.com/gateway/2.7.x/install-and-run/kubernetes/) and [Helm](https://docs.konghq.com/gateway/2.7.x/install-and-run/helm/) installation methods. This operator is being deprecated in favor of a replacement based on Golang (instead of Helm). During the version `v0.x.x` lifecycle of this tool we decided that Helm did not suite our needs for a robust feature-rich operator. Security updates for this repository will be continued for the time being; but new features and other requests will not be prioritized. You can track the progress of the successor operator [here](https://github.com/kong/operator) and we highly encourage feature requests and discussions on the new operator repository to let us know your use cases and needs.**

---

**Kong Operator** is a Kubernetes [operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) which manages [Kong Ingress Controller](https://github.com/Kong/kubernetes-ingress-controller/) instances.

With Kong Operator running in your cluster, you can spin up multiple instances of Kong, each of them configured by a `Kong` custom resource ([example][kong-cr-example]). See the [Quick Start][section-quick-start] section below to get up and running.

## Supported Kubernetes versions

* Kubernetes v1.15+
    * Try it out: Kong Operator runs on [microk8s][microk8s] but requires `dns` and `rbac` microk8s addons.
    * Note: Kong Ingress Controller v0.9 does not support the `spec.ingressClassName` field introduced in Kubernetes v1.18. Instead, use the (deprecated in v1.18) `kubernetes.io/ingress.class` annotation.
* OKD v4.3+

## Quick Start

1. Deploy kong-operator:
    1. Navigate to the [Kong operator at OperatorHub][operatorhub-kong].
    1. Click "Install".
    1. Follow the instructions described in the pop-up in order.
1. Deploy a Kong Ingress Controller with `example-ingress-class` Ingress class (see [_Configuration_ section][section-configuration] for available options):
    ```
    kubectl create -f - <<EOF
    apiVersion: charts.konghq.com/v1alpha1
    kind: Kong
    metadata:
      name: example-kong
    spec:
      proxy:
        type: NodePort
      env:
        prefix: /kong_prefix/
      resources:
        limits:
          cpu: 500m
          memory: 2G
        requests:
          cpu: 100m
          memory: 512Mi
      ingressController:
        enabled: true
        ingressClass: example-ingress-class
        installCRDs: false
    EOF
    ```
1. Deploy an example Service and expose it with an Ingress:
    1. Deploy the echo service:
        ```
        kubectl apply -f https://bit.ly/echo-service
        ```
    1. Create an Ingress:
        ```
        kubectl create -f - <<EOF
        apiVersion: networking.k8s.io/v1
        kind: Ingress
        metadata:
          name: demo
          annotations:
            # Note that the annotation below is deprecated as of Kubernetes 1.18
            # in favor of the new spec.ingressClassName field. At the moment of writing
            # (Kong Ingress Controller v0.9.0), Kong Ingress Controller does not support
            # the new format yet.
            kubernetes.io/ingress.class: example-ingress-class
        spec:
          rules:
          - http:
              paths:
              - path: /foo
                pathType: Prefix
                backend:
                  service:
                    name: echo
                    port:
                      number: 8080
        EOF
        ```
1. See that Kong works and relays requests to the application!
    ```
    PROXY_IP=$(kubectl get service example-kong-kong-proxy -o jsonpath={.spec.clusterIP})
    ```
    ```
    curl http://$PROXY_IP/foo/
    ```

1. _Optional_: See the list of Kong Ingress Controllers present in your cluster:
    ```
    kubectl get kongs

    # Example output:
    # NAME          AGE
    # example-kong  8m
    ```

1. _Optional_: Remove an existing Kong Ingress Controller from your cluster:
    ```
    kubectl delete kong example-kong
    ```

## Configuration

### Helm Operator

For every `Kong` resource applied to the cluster by `kubectl apply`, Kong Operator (being a [_Helm operator_][operator-sdk-helm] under the hood) operates a Helm release of [this Helm chart][helm-chart].
If you're interested in the inner workings, refer to [the official Helm documentation][helm-docs]. Note, though, that Kong Operator takes all the responsibility of running Helm. You are expected not to interact with Helm at all.

- When you `kubectl create` a `Kong` resource, Kong Operator will asynchronously install a new Helm release of Kong.
- When you `kubectl edit` or `kubectl patch` (or edit in some another way) an existing `Kong` resource, Kong Operator will upgrade the existing release of Kong.
- When you `kubectl delete` a `Kong` resource, Kong Operator will delete the existing release of Kong from the cluster.

Stopping the operator does not affect running Kong releases.

### `Kong` Spec

You can tailor the configuration of a Kong running in your Kubernetes cluster (if you have chosen Kong Operator as the way of deploying Kong) by defining the desired settings in the `.spec` field of the [`Kong` resource][kong-cr-example].

The reference of the `.spec` object (as well as the default values for unset fields) is the [`values.yaml`][helm-values-yaml] file.

If you create a `Kong` with an empty `.spec`, the Kong will have the default configuration (as per `values.yaml`). You can override a certain setting (e.g. `ingressController.enabled`) by setting the corresponding field under `.spec` of the `Kong` resource (in the aforementioned example: `.spec.ingressController.enabled`).

[kong-url]: https://konghq.com/
[kong-logo]: https://konghq.com/wp-content/uploads/2018/05/kong-logo-github-readme.png
[kong-cr-example]: deploy/crds/charts_v1alpha1_kong_cr.yaml
[microk8s]: https://microk8s.io
[section-quick-start]: #quick-start
[section-configuration]: #configuration
[helm-chart]: https://github.com/Kong/kong-operator/tree/main/helm-charts/kong
[helm-values-yaml]: https://github.com/Kong/kong-operator/blob/main/helm-charts/kong/values.yaml
[operatorhub-kong]: https://operatorhub.io/operator/kong
[operator-sdk-helm]: https://sdk.operatorframework.io/docs/helm/
[helm-docs]: https://helm.sh/docs/intro/using_helm/
