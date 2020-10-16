# Changelog

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
