This is a repo for fluxcd demo

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [kind](https://kind.sigs.k8s.io/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Flux CLI](https://fluxcd.io/flux/installation/) (`brew install fluxcd/tap/flux`)

## Local cluster

The cluster is defined in `kind/cluster.yaml`: one control-plane node and two workers, named `fluxcd-demo`. Ports 80 and 443 on the control-plane node are exposed on host ports 8080 and 8443 for ingress.

Create the cluster:

```sh
make cluster-up
```

This creates the cluster if it doesn't exist and waits for all nodes to be Ready. Verify with:

```sh
kubectl --context kind-fluxcd-demo get nodes
```

Delete the cluster:

```sh
make cluster-down
```

## Bootstrap Flux

Bootstrap installs Flux on the cluster and syncs it from this repo's GitHub repo (`troydai/fluxcd-demo`, branch `main`, path `clusters/fluxcd-demo`). Flux commits its own manifests to that path. It syncs over HTTPS using the token (`--token-auth`) rather than creating an SSH deploy key, so the token is stored in a Secret in the cluster (`flux-system/flux-system`). That is acceptable for a local kind cluster; revoke the token when you're done.

```sh
export GITHUB_TOKEN=<fine-grained personal access token>
make bootstrap
```

Override the defaults with `GITHUB_OWNER`, `GITHUB_REPO`, `GITHUB_BRANCH` and `FLUX_PATH` if needed. The script is safe to re-run.

### Getting a `GITHUB_TOKEN`

`GITHUB_TOKEN` is a GitHub personal access token (PAT). It isn't created automatically, so generate one. Always use a **fine-grained** token limited to this repository only, rather than a classic `repo`-scoped token, which grants access to every repository you own. The repository must already exist on GitHub.

1. Open <https://github.com/settings/personal-access-tokens/new> (GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token).
2. Name it (for example `fluxcd-demo`) and set a short expiration.
3. Under **Repository access**, choose **Only select repositories** and select only `troydai/fluxcd-demo`.
4. Under **Repository permissions**, set the following, as required by the [Flux docs](https://fluxcd.io/flux/installation/bootstrap/github/):
   - **Administration**: Read-only
   - **Contents**: Read and write
   - **Metadata**: Read-only (selected automatically)
5. Click **Generate token** and copy the value. GitHub only shows it once.
6. Export it in the shell where you run `make bootstrap`:

   ```sh
   export GITHUB_TOKEN=github_pat_xxxxxxxxxxxx
   ```

The token's user must also have `admin` permission on the repository (the owner does). Never commit the token.
