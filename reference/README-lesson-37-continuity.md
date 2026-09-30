# Lesson 37 continuity note

Status date: **2026-08-08**

## Current state

- Lesson 37: **Healthchecks, restart policies, resource limits, non-root**.
- File: `lessons/lesson-37-health-restart-resources-non-root.html`.
- Status: **created; awaiting study**.
- Lessons 32–36 retain their existing awaiting-study status.
- Next planned lesson: **38 — Checkpoint/restore (CRIU)**.

## Teaching structure used

Lesson 37 follows the approved pipeline-first clear-deep method. It opens with the whole movement path, then separates four terminal owners:

1. health probe result → `dockerd` health state;
2. main-task exit → `dockerd` restart manager;
3. resource values → OCI resources → runc/cgroups → Linux kernel enforcement;
4. configured user → numeric OCI `process.user` → runc credential setup → Linux process credentials.

## Pinned source family

- Docker Engine / Docker CLI 29.6.2
- containerd 2.2.6
- runc 1.3.6
- opencontainers/cgroups 0.0.4 (pinned by runc 1.3.6)
- OCI runtime-spec 1.3.0
- OCI image-spec 1.1.1
- Linux 6.18 cgroup-v2 documentation/source boundary

## Corrections to preserve

- `unhealthy` does not itself invoke restart policy.
- The restart-manager 10-second stable-run threshold resets backoff; it is not an activation delay.
- `memory.low` is reclaim protection, not a soft maximum.
- `cpu.max` quota and `cpu.weight` relative priority are different controls.
- Non-root credentials are not the same mechanism as a user namespace.

Do not modify Lesson 37 automatically if a later source audit finds a problem. Record the exact issue and recommend a targeted correction unless the learner explicitly approves a rebuild.
