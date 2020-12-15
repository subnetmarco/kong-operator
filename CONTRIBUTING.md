## Contributing to Kong Operator

Feel free to contribute fixes or minor features, we love to receive pull requests! If you are planning to develop a larger feature, please submit a GitHub issue describing your proposal first, to discuss it with the maintainers.

### Commit messages

Please format your commit messages according to [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## Stale issue and pull request policy

To ensure our backlog is organized and up to date, we will close issues and
pull requests that have been inactive awaiting a community response for over 2
weeks. If you wish to reopen a closed issue or PR to continue work, please
leave a comment asking a team member to do so.

### Build, test, run the operator

The [CI job](https://github.com/Kong/kong-operator/blob/main/.github/workflows/test.yaml) is a reference build/test workflow for Kong Operator.

## Releasing Kong Operator

Follow these instructions in order to release a new version of Kong Operator from `main`.

_For maintainers only_. These instructions require certain privileges (pushing the Docker image to Bintray, pushing Git tags, etc.).

1. Ensure that `HEAD` of `main` defines the release candidate of the operator:
    - set the right version in `build/Dockerfile`,
    - update the Helm chart vendored in this repo (in a clean working copy, run `./hack/update-kong-chart.sh kong-vA.B.C` where `kong-vA.B.C` is an existing tag in the charts repository)
    - ensure that `deploy/` manifests point to the new (nonexistent yet) operator image tag.
1. Define an OperatorHub release spec:
    - Create `/olm/X.Y.Z/` with the CSV and CRD manifests, similarly to [#37](https://github.com/Kong/kong-operator/pull/37) and [#39](https://github.com/Kong/kong-operator/pull/39). Pay particular attention to the following:
       - Always define [`skipRange`](https://docs.openshift.com/container-platform/4.2/operators/understanding_olm/olm-understanding-olm.html#olm-upgrades-replacing-multiple_olm-understanding-olm) to specify a range of versions which support a direct update to the version you're releasing,
        - Set `replace` to the previous latest version.
    - Update `/olm/kong.package.yaml` similarly to [#42](https://github.com/Kong/kong-operator/pull/42)
    - Merge these changes to `main`.
1. Update CHANGELOG.md. If Helm chart changes include breaking changes, please include a link to their [UPGRADE.md](https://github.com/Kong/charts/blob/main/charts/kong/UPGRADE.md) section under a **Breaking Changes** header.
1. Ensure that `HEAD` of `main` with all the above changes has a green CI status.
1. Create a Git tag in the format `vX.Y.Z`.
1. Create a GitHub [release](https://github.com/Kong/kong-operator/releases) from the new tag.
1. Navigate to [the Test workflow](https://github.com/Kong/kong-operator/actions?query=workflow%3ATest) on GitHub Actions, find the run labeled with  the `vX.Y.Z`, and download the build artifact called **operator-image**. This is the Docker image which you will push to Bintray in the following step.
1. Push the `kong-operator` image to Bintray:
    - `docker login` to the `kong-operator` registry on Bintray: click _Set me up_ on the [kong-operator registry page](https://bintray.com/beta/#/kong/kong-operator/kong-operator?tab=overview) for instructions.
    -
        ```bash
        # Unzip the artifact downloaded from GitHub.
        unzip operator-image.zip
        # Load the image (extracted from the artifact) into Docker. The image is tagged as kong-operator:ci.
        docker load < kong-operator-ci.tar
        # Tag the released artifact.
        docker tag kong-operator:ci kong-docker-kong-operator.bintray.io/kong-operator:vX.Y.Z
        # Push to Bintray.
        docker push kong-docker-kong-operator.bintray.io/kong-operator:vX.Y.Z
        ```
1. _Optional:_ verify that manifests from `deploy/` can deploy the newly pushed operator successfully.
1. Create and merge a PR to [operator-framework/community-operators](https://github.com/operator-framework/community-operators) defining the new release for OLM:
     - Create a `release/vX.Y.Z` branch in [Kong/community-operators](https://github.com/Kong/community-operators) from the `master` of the [fork base](https://github.com/operator-framework/community-operators).
     - Create **one single** commit which `upstream-community/operators/kong` directory contents with `olm/` versioned at the tag `vX.Y.Z` (the one you're releasing) this repository.
         - Have the commit signed off (`commit [--amend] -s`) by a maintainer.
     - When creating a PR, obey the guidelines described in the PR template.
1. When the PR is merged by community-operators' maintainers, the release is done.
