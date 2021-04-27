# Changelog

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
