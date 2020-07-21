# Kong Operator
[![][kong-logo]][kong-url]

**Kong Operator** is a Kubernetes [operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) which manages [Kong Ingress Controller](https://github.com/Kong/kubernetes-ingress-controller/) instances.

With Kong Operator running in your cluster, you can spin up multiple instances of Kong, each of them configured by a `Kong` custom resource ([example][kong-cr-example]). See the [Quick Start][quick-start] section below to get up and running.

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
1. Deploy a Kong Ingress Controller with `example-ingress-class` Ingress class (see [the example `Kong` resource][kong-cr-example] for available options):
    ```
    kubectl create -f - <<EOF
    apiVersion: charts.helm.k8s.io/v1alpha1
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
        apiVersion: extensions/v1beta1
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
                backend:
                  serviceName: echo
                  servicePort: 8080
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



[kong-url]: https://konghq.com/
[kong-logo]: https://konghq.com/wp-content/uploads/2018/05/kong-logo-github-readme.png
[kong-cr-example]: deploy/crds/charts_v1alpha1_kong_cr.yaml
[microk8s]: https://microk8s.io
[quick-start]: #quick-start
[operatorhub-kong]: https://operatorhub.io/operator/kong
