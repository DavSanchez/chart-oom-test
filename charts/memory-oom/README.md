# memory-oom Helm Chart

A minimal chart that deploys a pod which progressively allocates memory until the container is OOMKilled. Useful for testing Kubernetes CrashLoopBackOff behavior and related observability.

## Install

```fish
# From the workspace root
helm upgrade --install oom-test ./charts/memory-oom
```

## Parameters

- `image.repository`: Container image (default `alpine`).
- `image.tag`: Image tag (default `3.19`).
- `memory.stepBytes`: Bytes allocated per step (default `1048576` = 1MiB).
- `memory.intervalSeconds`: Delay between allocations (default `0.2`).
- `memory.steps`: Total allocation steps; set high to reach OOM.
- `resources.requests.*`: Small defaults to avoid cluster impact.
- `resources.limits.*`: Keep memory low (default `32Mi`) to trigger OOM.
- `restartPolicy`: Defaults to `Always` to enable CrashLoopBackOff.
- `replicaCount`: Number of pods in the Deployment (default `1`).

Override values:

```fish
helm upgrade --install oom-test ./charts/memory-oom \
  --set memory.stepBytes=2097152 \
  --set memory.intervalSeconds=0.1 \
  --set resources.limits.memory=24Mi
```

## Observe

```fish
kubectl get pods -l app.kubernetes.io/name=memory-oom -w
kubectl describe pod -l app.kubernetes.io/name=memory-oom
kubectl logs -f deploy/oom-test-memory-oom
```

Expect the pod to restart with `CrashLoopBackOff` after OOMKilled.

## Notes

- The container uses `python3` launched from `alpine` to allocate memory via `bytearray` chunks.
- Keep limits low to avoid cannibalizing cluster resources.
- Adjust `memory.stepBytes` and `intervalSeconds` to tune speed of OOM.
