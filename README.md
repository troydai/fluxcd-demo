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
