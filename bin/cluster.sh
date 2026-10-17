#!/usr/bin/env bash
# Create or delete the local kind cluster used for the Flux demo.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG="${ROOT}/kind/cluster.yaml"
NAME="fluxcd-demo"

case "${1:-}" in
  up)
    if kind get clusters | grep -qx "${NAME}"; then
      echo "cluster ${NAME} already exists"
    else
      kind create cluster --config "${CONFIG}"
    fi
    kubectl --context "kind-${NAME}" wait --for=condition=Ready nodes --all --timeout=120s
    ;;
  down)
    kind delete cluster --name "${NAME}"
    ;;
  *)
    echo "usage: $0 {up|down}" >&2
    exit 1
    ;;
esac
