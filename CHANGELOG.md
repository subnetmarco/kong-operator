# Changelog

## 0.9.0

### Breaking changes

* 0.9.0 changes the API group used for the Kong CRD to `charts.konghq.com`.
  This is necessary to comply with new requirements for `*.k8s.io` groups
  enforced by Kubernetes 1.22 and newer. Because of this change, you **cannot
  upgrade to 0.9.0 from previous releases of the operator, and must manually
  copy configuration from your existing kongs.charts.helm.k8s.io CRs into new
  kongs.charts.konghq.com CRs.** See the "Upgrading from previous versions"
  section below for detailed instructions.
* Chart 2.4 updates the default version of KIC to 2.0. If you do not override
  your KIC version to an older 1.x version and you use a database, you should
  [temporarily disable KIC before upgrading it to 2.0](https://github.com/Kong/charts/blob/kong-2.4.0/charts/kong/UPGRADE.md#disable-ingress-controller-prior-to-2x-upgrade-when-using-postgresql)
  to avoid database inconsistency.
* ServiceAccount configuration has a [new location inside Kong custom
  resources](https://github.com/Kong/charts/blob/kong-2.4.0/charts/kong/UPGRADE.md#changed-serviceaccount-configuration-location)
  to support configurations that require a ServiceAccount but do not use the
  ingress controller.
* Various resources [now use updated API versions](https://github.com/Kong/charts/blob/kong-2.4.0/charts/kong/UPGRADE.md#changed-serviceaccount-configuration-location)
  for compatibility with newer Kubernetes releases. These versions require
  Kubernetes 1.16 or newer. Note that the upgraded Ingress resources now use
  the `ingressClassName` field: you should remove `ingress.class` annotations
  and set their value in `ingressClassName` to account for [changes to the
  Ingress spec](https://docs.konghq.com/kubernetes-ingress-controller/2.0.x/concepts/ingress-versions/).
* The [Pod disruption budget default has changed](https://github.com/Kong/charts/blob/kong-2.4.0/charts/kong/UPGRADE.md#changes-to-pod-disruption-budget-defaults)
  to allow support for the `minUnavailable` setting. You may wish to restore
  the older default if you are upgrading from a previous version.

### Upgrading from previous versions

0.9.0 changes the CRD API group used by this operator. The new
`kongs.charts.konghq.com` CRD and old `kongs.charts.helm.k8s.io` CRD have
identical specs, but you must manually copy data into new CRs to migrate your
configuration. We recommend backing up your cluster prior to migrating.

Because the old CRD is not compatible with Kubernetes 1.22, you must complete
these steps on Kubernetes 1.21 or older. To migrate your configuration:

1. Install the new CRD:
   ```
   kubectl create -f https://raw.githubusercontent.com/Kong/kong-operator/v0.9.0/deploy/crds/charts_v1alpha1_kong_crd.yaml
   ```
2. Using [jq](https://stedolan.github.io/jq/), create new CRs from your
   existing CRs:
   ```
   kubectl get kongs.charts.helm.k8s.io -o json | jq ".items[] | del(.metadata.uid, .metadata.creationTimestamp, .metadata.generation, .metadata.resourceVersion) | .apiVersion=\"charts.konghq.com/v1alpha1\"" | kubectl create -f -
   ```
3. Plan an outage window where you will upgrade to Kubernetes 1.22 and install
   the new operator. Because you will uninstall previous versions of the
   operator, there will be a period when your Kong instances will not be
   available.
4. Begin your outage window. [Uninstall the Kong operator](https://olm.operatorframework.io/docs/tasks/uninstall-operator/)
   and run `kubectl delete crds kongs.charts.helm.k8s.io`. This will _stop
   currently running Kong instances_.
5. Install Kong operator 0.9.0. Check the status of your Kong instances. 0.9.0
   should detect the new CRs and start Kong instances automatically.

### Improvements

* Upgraded to chart 2.4. See the [chart changelog](https://github.com/Kong/charts/blob/kong-2.4.0/charts/kong/CHANGELOG.md)
  for full details.
* Upgraded the Kong CRD API version to `apiextensions.k8s.io/v1` for
  compatibility with Kubernetes 1.22 and newer.

## 0.8.0

### Breaking changes

* Chart 2.1 includes 2.0 changes. 2.0 ends support for Helm 2 and removes
  support for all deprecated configuration in 1.14. Please review the [2.0
  upgrade guide for details](https://github.com/Kong/charts/blob/kong-2.1.0/charts/kong/UPGRADE.md#200).
* Bintray, the Docker registry previously used for several Kong images, is
  discontinuing service. Affected images have moved to Docker Hub. The latest
  defaults reflect this, but existing your existing Kong custom resources may
  still reference the old repositories. Review your CRs to see if they contain
  `bintray.io`, and if so, replace those repositories with the repositories in
  the [2.1 values.yaml](https://github.com/Kong/charts/blob/kong-2.1.0/charts/kong/values.yaml).

### Improvements

* Updated Helm chart to 2.1.
* Updated existing OLM CSVs to use the Docker Hub repo for the operator image.

## 0.7.0

### Breaking changes

* Chart 1.14 introduces breaking changes to proxy Ingress configuration and
  readiness/liveness monitors. Please see [the 1.14 upgrade
  instructions](https://github.com/Kong/charts/blob/kong-1.14.0/charts/kong/UPGRADE.md#1140)
  for further details.

### Improvements

* Updated Helm chart to 1.14.

## 0.6.0

### Improvements

* Updated Helm chart to 1.12.

## 0.5.0

### Breaking changes

* Chart 1.11 introduces a number of breaking changes, both in the chart itself
  and in its dependencies. Please read through the upgrade instructions for
  [chart 1.9](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md#190),
  [chart 1.10](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md#1100),
  and [chart 1.11](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md#1111)
  for details.
* In particular, if you use a Postgres-backed deployment, review the chart 1.9
  instructions for the [new Postgres readiness check script](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md#changes-to-wait-for-postgres-image).
  These changes require that you perform an initial upgrade without changing
  the Kong image version with migrations disabled before re-enabling migrations
  and setting a new Kong image.

### Improvements

* Updated Helm chart to 1.11.

## 0.4.0

### Improvements

* Updated Helm chart to 1.8.

## 0.3.0

### Improvements

* Updated Helm chart to 1.7.
* Added parallel fork/certified branch for the certified version of the
  Kong Operator.

### Documentation

* Added CHANGELOG.md with historical changes through 0.2.6.

## 0.2.6

### Improvements

* Updated Helm chart to 1.5.
* Reworked ALM examples.
* Provided `replaces` metadata for moving from 0.1.0 to 0.2.6.
