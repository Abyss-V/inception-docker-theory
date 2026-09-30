# Continue from Lesson 44 — final security lesson created

This bundle is the source of truth for the existing Docker internals course. On **2026-08-09**, the learner explicitly approved a structural merge of the former planned final three security lessons into one compact final Lesson 44. The course therefore now contains **44 numbered lessons**. Do not recreate Lessons 45 or 46 unless the learner explicitly reverses that decision.

## Current state

- Lessons **1–31**: studied.
- Lessons **32–44**: HTML exists and remains **awaiting study** unless the learner explicitly says otherwise.
- Lesson 44 is the final numbered lesson: **Docker security boundary: rootless Docker, plugins/authz, and daemon-socket authority**.
- Former planned Lessons 45 and 46 were **absorbed into Lesson 44**, not omitted.
- There is no next numbered lesson in the current approved course.

## Lesson 44 canonical model

Teach security as three distinct layers:

1. **Workload sandbox** — container user, namespaces, capabilities, seccomp, LSMs, cgroups. These were taught earlier.
2. **API authorization** — transport/socket access plus optional Docker authorization-plugin middleware controlling which Engine requests are accepted.
3. **Daemon privilege boundary** — rootful versus rootless dockerd determines the outer host authority available when an allowed request is executed.

Canonical pipeline:

`Docker CLI/API client → Engine socket/transport → optional AuthZRequest plugin chain → dockerd Engine handler → optional AuthZResponse chain → ordinary dockerd → containerd → shim → runc → Linux kernel execution path`

Rootless startup must be explained separately:

`host user → dockerd-rootless.sh → RootlessKit creates unprivileged user/mount/network namespaces → dockerd starts inside that environment → ordinary runtime pipeline`

Precision rule: **`docker.sock = root` is conditional on a rootful daemon.** The socket is an authority endpoint; the root-level consequence comes from the host-root daemon behind it. A rootless socket still grants control over that user's daemon, but the daemon itself lacks normal host-root authority.

## Sources

Keep the Docker Engine / Docker CLI **29.6.2** baseline. Lesson 44's exact anchors are recorded in `reference/source-baseline-and-corrections.md`, especially the pinned Engine rootless scripts, listener, container-create `HostConfig`, and `pkg/authorization` middleware/plugin implementation.

## Workflow

There is no planned Lesson 45. Continue by helping the learner study Lesson 44, answering source-backed follow-up questions, or making a targeted clarity correction if requested. Never mark Lesson 44 studied unless the learner explicitly says it has been studied.

Every future approved lesson/rebuild artifact change must still be accompanied by a refreshed cumulative handoff bundle.
