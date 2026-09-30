# Docker course map

Status date: **2026-08-09**

This is the approved **44-lesson current order**. On 2026-08-09 the learner explicitly approved merging the former planned security Lessons 44–46 into one final Lesson 44. Do not otherwise reorder, renumber, merge, or add a numbered lesson without explicit approval.

Legend: **studied** = HTML exists and learner has completed it; **next** = next lesson to create; **planned** = not yet created.

## Part 1 — Foundations & architecture

1. **What containerization is** — `CORE` — **studied**
2. **The architecture chain** — `CORE` — **studied**
3. **Docker contexts & remote daemons** — `DEEP-CUT` — **studied**
4. **containerd internals: plugin model** — `DEEP-CUT` — **studied**
5. **The shim in depth** — `CORE` — **studied**
## Part 2 — Kernel primitives

6. **Namespaces** — `CORE` — **studied**
7. **User namespaces & userns-remap** — `CORE` — **studied**
8. **docker exec & setns** — `CORE` — **studied**
9. **cgroups v1** — `DEEP-CUT` — **studied**
10. **cgroups v2** — `CORE` — **studied**
11. **Capabilities** — `CORE` — **studied**
12. **seccomp** — `CORE` — **studied**
13. **AppArmor & SELinux** — `DEEP-CUT` — **studied**
14. **OCI lifecycle & hooks** — `DEEP-CUT` — **studied**
## Part 3 — Storage & images

15. **OverlayFS & copy-on-write** — `CORE` — **studied**
16. **Snapshotters & storage-driver landscape** — `DEEP-CUT` — **studied**
17. **What an image layer physically is** — `CORE` — **studied**
   - Approved unnumbered supplement after this lesson: **ChainID explained**.
18. **Images: manifest, config, media types, digests** — `CORE` — **studied**
19. **Multi-arch / manifest lists** — `DEEP-CUT` — **studied**
20. **OCI image layout on disk** — `DEEP-CUT` — **studied**
21. **The runtime-spec config.json** — `CORE` — **studied**
22. **Content store & GC / leases** — `DEEP-CUT` — **studied**
## Part 4 — Pipelines & Dockerfiles

23. **The run pipeline, end to end** — `CORE` — **studied**
24. **The legacy build pipeline** — `DEEP-CUT` — **studied**
25. **BuildKit: LLB, frontends, solver, cache** — `CORE` — **studied**
26. **Dockerfiles: every instruction, exec vs shell** — `CORE` — **studied**
27. **Multi-stage builds & the build graph** — `CORE` — **studied**
28. **PID 1 in depth** — `CORE` — **studied**
29. **Build context & .dockerignore** — `CORE` — **studied**
30. **ARG vs ENV & the history leak** — `CORE` — **studied**
31. **Layer caching & hygiene** — `CORE` — **studied**
## Part 5 — Runtime concerns

32. **Volumes vs bind mounts vs tmpfs** — `CORE` — **created; awaiting study**
33. **Networking I: net ns, veth, bridge/host/none, DNAT** — `CORE` — **created; awaiting study by explicit learner instruction; Lesson 32 study status unchanged**
34. **Networking II: user-defined bridges, embedded DNS, macvlan/ipvlan** — `CORE` — **created; awaiting study by explicit learner instruction; Lessons 32–33 study status unchanged**
35. **stdio & logging** — `DEEP-CUT` — **created; awaiting study; pipeline-first clear-deep rebuild completed against Docker Engine 29.6.2 / containerd 2.2.6 / runc 1.3.6 / OCI runtime-spec 1.3.0**
36. **Config & secrets** — `CORE` — **created; awaiting study; pipeline-first clear-deep rebuild aligned to Docker Engine/Docker CLI 29.6.2, OCI runtime-spec 1.3.0, and separately pinned Compose v5.1.4 / compose-go v2.11.0**
37. **Healthchecks, restart policies, resource limits, non-root** — `CORE` — **created; awaiting study; pipeline-first source-aligned build completed against Docker Engine 29.6.2 / containerd 2.2.6 / runc 1.3.6 / opencontainers/cgroups 0.0.4 / OCI runtime-spec 1.3.0 / OCI image-spec 1.1.1 / Linux 6.18**
38. **Checkpoint/restore (CRIU)** — `DEEP-CUT` — **created; awaiting study; second clarity rebuild completed 2026-08-09 with the same source baseline, now centered on one concrete process-state example and a single checkpoint→restore causal path; CRIU v4.2.1 remains independently pinned for CRIU internals**
## Part 6 — Distribution

39. **Registries & the OCI distribution-spec HTTP API** — `CORE` — **created; awaiting study; clarity rebuild completed 2026-08-09 against unchanged Docker Engine/Docker CLI 29.6.2 / containerd 2.2.6 / OCI distribution-spec 1.1.1 / OCI image-spec 1.1.1 baseline; main path now teaches only pull/push movement, with Lesson 40/41 concepts explicitly deferred**
40. **Tags vs digests, content-addressed transfer & dedup** — `CORE` — **created; awaiting study; second clarity rebuild completed 2026-08-09 against unchanged Docker Engine/Docker CLI 29.6.2 / containerd 2.2.6 / OCI image-spec 1.1.1 / OCI distribution-spec 1.1.1 baseline; teaching now starts with one tag and one root manifest, then separates tag resolution, local digest lookup, verification, graph reuse, push HEAD dedup, and cross-repository mount**
41. **Image signing & provenance** — `DEEP-CUT` — **created; awaiting study; pipeline-first source-aligned build completed 2026-08-09 against BuildKit 0.31.1 / OCI image-spec 1.1.1 / OCI distribution-spec 1.1.1, with Cosign v3.0.6 independently pinned for the external signing/verification implementation; provenance and cryptographic signing are taught as separate pipelines**
## Part 7 — Orchestration

42. **docker compose** — `CORE` — **created; awaiting study; pipeline-first source-aligned build completed 2026-08-09 against parent Docker CLI/Docker Engine 29.6.2 and independently pinned Docker Compose v5.1.4 / compose-go v2.11.0; teaches Compose as a client-side project-model loader and Engine-API reconciler, not a container runtime**
43. **Swarm mode** — `DEEP-CUT` — **created; awaiting study; compact pipeline-first source-aligned build completed 2026-08-09 against Docker Engine/Docker CLI 29.6.2 and the Engine-pinned SwarmKit v2.1.3-0.20260609123145-f80b112cff7d (commit f80b112cff7d2fa4b67eff36f0bdd2cbd05be0d8); teaches Service → Task → container, Raft-backed manager state, leader reconciliation/scheduling, worker assignment/execution, replacement-task recovery, and overlay/VIP networking**
## Part 8 — Security capstone

44. **Docker security boundary: rootless Docker, plugins/authz, and daemon-socket authority** — `CORE` — **created; awaiting study; final compact security lesson created 2026-08-09 against Docker Engine/Docker CLI 29.6.2; explicitly absorbs the former planned Lessons 45–46 without dropping their mechanisms**

**Approved structural merge (2026-08-09):** the former planned `44 Rootless Docker`, `45 Plugins & authz`, and `46 Security capstone: docker.sock = root` were combined at the learner's explicit request. The course now ends at numbered Lesson 44. The former 45/46 topics are part of Lesson 44, not deleted content.

## Dependency rule

Each lesson may rely on earlier lessons only. Forward references are one short pointer, not a mini-lesson. Lesson 31 relies on Lessons 15, 17, 25, 29, and 30. Lesson 32 relies on Lessons 3, 15, 21, 23, and 31. Lesson 33 relies on the namespace/runtime foundations and was created by explicit learner instruction while Lesson 32 remained recorded as awaiting study; that creation exception does not retroactively mark Lesson 32 studied. Lesson 34 was created by explicit learner instruction while Lessons 32 and 33 remained recorded as awaiting study; that creation exception does not retroactively mark either earlier lesson studied. Lesson 35 was created by explicit learner instruction while earlier runtime lessons remained recorded as awaiting study; no study completion is inferred. Its first continuation build briefly used the wrong 29.7.2 baseline, but that draft is superseded: the current Lesson 35 has been rebuilt against the authoritative Docker Engine 29.6.2 / containerd 2.2.6 / runc 1.3.6 / OCI runtime-spec 1.3.0 baseline. Lesson 36 was likewise created by explicit learner instruction without inferring study completion for Lessons 32–35; its current learner-facing build is aligned to Docker Engine/Docker CLI 29.6.2 and OCI runtime-spec 1.3.0, with Compose v5.1.4 / compose-go v2.11.0 pinned independently. Lesson 37 was created by explicit learner instruction while Lessons 32–36 remained recorded as awaiting study; its creation does not infer study completion for any prerequisite. Lesson 38 was then created by explicit learner instruction while Lessons 32–37 remained recorded as awaiting study; its creation likewise does not infer study completion for any prerequisite. Lesson 39 was then created by explicit learner instruction while Lessons 32–38 remained recorded as awaiting study; its creation likewise does not infer study completion for any prerequisite. Lesson 40 was then created by explicit learner instruction while Lessons 32–39 remained recorded as awaiting study; its creation likewise does not infer study completion for any prerequisite. Lesson 41 was then created by explicit learner instruction while Lessons 32–40 remained recorded as awaiting study; its creation likewise does not infer study completion for any prerequisite. Lesson 42 was then created by explicit learner instruction while Lessons 32–41 remained recorded as awaiting study; its creation likewise does not infer study completion for any prerequisite. Lesson 43 was then created by explicit learner instruction while Lessons 32–42 remained awaiting study. On 2026-08-09 the learner explicitly approved the final security merge, so Lesson 44 absorbs the former planned Lessons 44–46 and completes the numbered course. No other redesign is authorized.
