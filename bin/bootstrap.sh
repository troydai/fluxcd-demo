#!/usr/bin/env bash
# Bootstrap Flux on the kind cluster, using this repo's GitHub repo as the source.
# Requires GITHUB_TOKEN (a fine-grained PAT, see README) in the environment.
# --token-auth syncs over HTTPS with the token instead of creating an SSH deploy key,
# so the token only needs Contents read/write (no Administration write).
set -euo pipefail

NAME="fluxcd-demo"
OWNER="${GITHUB_OWNER:-troydai}"
REPO="${GITHUB_REPO:-fluxcd-demo}"
BRANCH="${GITHUB_BRANCH:-main}"
FLUX_PATH="${FLUX_PATH:-clusters/${NAME}}"

if [[ -z "${GITHUB_TOKEN:-}" ]]; then
  echo "GITHUB_TOKEN is not set" >&2
  exit 1
fi

for cmd in flux kubectl; do
  command -v "${cmd}" >/dev/null || { echo "${cmd} not found" >&2; exit 1; }
done

kubectl config get-contexts "kind-${NAME}" >/dev/null 2>&1 || {
  echo "context kind-${NAME} not found; run 'make cluster-up' first" >&2
  exit 1
}

flux check --pre --context "kind-${NAME}"

flux bootstrap github \
  --context "kind-${NAME}" \
  --owner "${OWNER}" \
  --repository "${REPO}" \
  --branch "${BRANCH}" \
  --path "${FLUX_PATH}" \
  --token-auth \
  --personal
