# Progress and approved decisions

Status date: **2026-08-09**

## Progress

- Current approved course size: **44 numbered lessons**. The learner explicitly merged the former planned Lessons 44–46 into final Lesson 44 on 2026-08-09.
- Lessons **1–28**: HTML exists and has been studied.
- Approved unnumbered supplement: **ChainID explained**, placed after Lesson 17.
- Lesson **29 — Build context & `.dockerignore`**: studied after the learner-facing clarity rebuild and follow-up questions.
- Lesson **30 — ARG vs ENV & the history leak**: studied after the learner completed the lesson and resolved follow-up questions about provenance, secret records, and predefined proxy arguments.
- Lesson **31 — Layer caching & hygiene**: studied after the state-transition-first clarity rebuild and follow-up explanations about `RUN` inputs, network freshness, and cache invalidation controls.
- Lesson **32 — Volumes vs bind mounts vs tmpfs**: created from the pinned Moby/runc/runtime-spec baseline; awaiting study.
- Lesson **33 — Networking I: net ns, veth, bridge/host/none, DNAT**: created from the pinned Moby/runc/runtime-spec/Linux 6.18 baseline after explicit learner instruction; awaiting study.
- Lesson **34 — Networking II: user-defined bridges, embedded DNS, macvlan/ipvlan**: created from the pinned Moby/Linux 6.18 baseline after explicit learner instruction; awaiting study.
- Lesson **35 — stdio & logging**: compact source-aligned rebuild completed on 2026-08-08 against Moby 29.6.2, containerd 2.2.6, runc 1.3.6, and OCI runtime-spec 1.3.0; created and awaiting study.
- Lesson **36 — Config & secrets**: compact source-aligned rebuild completed on 2026-08-08 after rereading continuity/reference files and prerequisite lessons; created/awaiting study by explicit learner instruction.
- Lesson **37 — Healthchecks, restart policies, resource limits, non-root**: pipeline-first source-aligned standalone lesson completed on 2026-08-08 against the pinned Engine/runtime/OCI/Linux family; created and awaiting study.
- Lesson **38 — Checkpoint/restore (CRIU)**: pipeline-first source-aligned standalone lesson completed on 2026-08-08 against the pinned Engine/runtime/OCI family, with CRIU v4.2.1 independently pinned for CRIU internals; created and awaiting study.
- Lesson **39 — Registries & the OCI distribution-spec HTTP API**: pipeline-first source-aligned standalone lesson completed on 2026-08-08 against Docker Engine/Docker CLI 29.6.2, containerd 2.2.6, OCI distribution-spec 1.1.1, and OCI image-spec 1.1.1; created and awaiting study.
- Lesson **40 — Tags vs digests, content-addressed transfer & dedup**: pipeline-first source-aligned standalone lesson completed on 2026-08-09 against Docker Engine/Docker CLI 29.6.2, containerd 2.2.6, OCI image-spec 1.1.1, and OCI distribution-spec 1.1.1; created and awaiting study.
- Lesson **41 — Image signing & provenance**: pipeline-first source-aligned standalone lesson completed on 2026-08-09 against BuildKit 0.31.1, OCI image-spec 1.1.1, and OCI distribution-spec 1.1.1, with Cosign v3.0.6 independently pinned as the external signer/verifier because Docker CLI 29 removed its old built-in Docker Content Trust workflow; created and awaiting study.
- Lesson **42 — docker compose**: pipeline-first source-aligned standalone lesson completed on 2026-08-09 against parent Docker CLI/Docker Engine 29.6.2 and independently pinned Docker Compose v5.1.4 / compose-go v2.11.0; created and awaiting study.
- Lesson **43 — Swarm mode**: compact pipeline-first source-aligned standalone lesson completed on 2026-08-09 against Docker Engine/Docker CLI 29.6.2 and the Engine-pinned SwarmKit commit f80b112cff7d2fa4b67eff36f0bdd2cbd05be0d8; created and awaiting study.
- Lesson **44 — Docker security boundary: rootless Docker, plugins/authz, and daemon-socket authority**: created on 2026-08-09 as the learner-approved compact merge of the former planned Lessons 44–46; awaiting study.
- There is no later numbered lesson in the approved course; Lesson 44 is the final course lesson.
- Continuity exception: Lesson 33 creation was explicitly requested while Lesson 32 was still recorded as awaiting study, Lesson 34 while Lessons 32–33 were awaiting study, Lesson 35 in the current continuation without inferring those study completions, Lesson 36 while Lessons 32–35 remained unmarked as studied, Lesson 37 while Lessons 32–36 remained unmarked as studied, Lesson 38 while Lessons 32–37 remained unmarked as studied, Lesson 39 while Lessons 32–38 remained unmarked as studied, Lesson 40 while Lessons 32–39 remained unmarked as studied, Lesson 41 while Lessons 32–40 remained unmarked as studied, and Lesson 42 while Lessons 32–41 remained unmarked as studied, and Lesson 43 while Lessons 32–42 remained unmarked as studied, and the merged Lesson 44 while Lessons 32–43 remained unmarked as studied. Creation does not retroactively mark any prerequisite lesson studied.
- No new consolidation lesson is approved. Lesson 23 already consolidates the run pipeline.

## Preservation decision

Keep Lessons 1–28. Do not rebuild them wholesale. Preserve the learner's progress and the approved revised versions of Lessons 7, 11, 12, and 17. Make only source-supported targeted corrections.

## Teaching decisions accumulated during study

- Intuition before terminology.
- Never present a chain of technical names without unpacking each term that is required now.
- Forward references are one short pointer.
- Explain the load-bearing code or specification behavior, not every line.
- Large raw source-code panels are omitted from the main narrative in new lessons; primary-source research and exact provenance remain mandatory.
- Diagrams are exceptional and reserved for genuinely complex spatial, state, or flow relationships.
- Keep inspect-it-yourself commands.
- `CORE` and `DEEP-CUT` labels mark priority, not reduced depth.
- For precise follow-up questions, inspect primary source before answering; do not improvise from memory.

## Transfer correction pass

A targeted correction pass was applied on 2026-08-06. It repaired stale lesson numbers and added precision corrections for:

- the containerd runtime-v2 shim relationship and current bootstrap/grouping behavior;
- OCI v1.3.0 hook guarantees and `poststop` timing;
- Dockerfile parser directives and deprecated `MAINTAINER` completeness;
- PID-namespace signal semantics, shell-as-PID-1 nuance, and configurable stop timeout.

The original uploaded archive remains unchanged; corrected lessons are distributed separately.

## Lesson 29 creation and clarity-rebuild record

Lesson 29 was created on 2026-08-06 after reviewing Lessons 25–28 and inspecting BuildKit v0.31.1, its pinned `moby/patternmatcher v0.6.1`, and the official Docker context and Dockerfile references. After the learner reported that the first version was difficult to understand, the lesson was rebuilt around one concrete project and three separate questions: the context boundary, the paths requested by the Dockerfile, and the paths removed by `.dockerignore`. The implementation depth and source baseline were preserved; low-level source identifiers were moved into a collapsed second-read appendix. It was marked studied after the learner completed the rebuilt version and resolved the remaining follow-up questions.

## Lesson 30 creation record

Lesson 30 was created on 2026-08-06 after reviewing Lessons 18, 25, 27, and 29 and inspecting BuildKit v0.31.1, OCI image-spec v1.1.1, and the official Docker build-variable and secret-mount references. It uses one `APP_VERSION`/`APP_MODE` example to separate three storage locations: the current build-stage state, the output image configuration, and history/provenance metadata. Large source excerpts remain in a collapsed appendix. The hands-on experiment demonstrates runtime defaults, image config, history exposure, and temporary secret mounts.

## Lesson 30 study completion record

Lesson 30 was marked studied on 2026-08-07 after follow-up explanations separated image history from provenance, explained why secret mounts record an identifier rather than a payload, and clarified the narrow predefined-proxy exception. No lesson rebuild was requested.

## Lesson 31 creation record

Lesson 31 was created on 2026-08-07 after reviewing Lessons 15, 17, 24–26, 29, and 30 and inspecting BuildKit v0.31.1 cache-key construction, file content hashing, execution dependencies, persistent cache mounts, and OCI image-spec v1.1.1 whiteout semantics. It uses one small application to distinguish operation-result cache from cache mounts and includes experiments for dependency invalidation, mtime omission, later-layer whiteouts, and persistent cache-mount state.

## Lesson 31 clarity-rebuild record

After the learner reported that Lesson 31 was not clear, it was rebuilt without changing the source baseline or technical coverage. The revision now begins with one plain cache question—whether an operation with the same inputs has already been solved—then follows one project through an unchanged rebuild, an application-source change, and a dependency-input change. Abstract cache-key terminology is introduced only after the observable behavior. Layer hygiene is separated from cache reuse, and cache mounts are presented as a second cache mechanism after a first-read checkpoint. Sharing modes, exact whiteout inspection, and the deterministic cache-mount experiment are moved into optional second-read sections. Lesson 31 was later marked studied after the learner completed the rebuilt version and follow-up explanations.


## Lesson 31 second clarity rebuild record

After the learner reported that the first clarity rebuild still did not build the idea coherently, Lesson 31 was rebuilt again from the foundational relationship that every filesystem operation receives one state and produces the next. The revision derives cache reuse, dependency propagation, image-layer changesets, same-operation cleanup, and cache mounts from that one state-transition model. All advanced topics remain visible; no mechanism was compressed into an optional-only section. Lesson 31 was later marked studied after the learner completed the rebuilt version and follow-up explanations.

## Lesson 32 creation record

Lesson 32 was created on 2026-08-07 after rereading `lesson-method.md`, reviewing Lessons 3, 15, 21, 23, and 31, and inspecting Docker Engine/Moby 29.6.2, runc 1.3.6, and OCI runtime-spec 1.3.0. The lesson deliberately starts with one path (`/data`) and one relationship—mounting changes what storage that path points to—before introducing bind mounts, Docker volumes, tmpfs, OCI translation, volume population, and lifecycle. It uses one compact path map rather than a large diagram and keeps the implementation anchors in prose and a collapsed appendix.

## Lesson 33 creation record

Lesson 33 was created on 2026-08-07 after rereading the continuity/reference files, reviewing Lessons 6, 8, 12, 14, 21, 23, and 32, reporting the required research checkpoint, and receiving explicit learner approval to proceed. The lesson is built against Moby 29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, and Linux 6.18 networking documentation/source. It starts from one relationship—network-namespace isolation does not itself provide connectivity—then follows the real setup order through OCI namespace selection, the created-task-before-start window, veth placement, Linux bridge attachment, addressing/gateway, host IP forwarding, outbound masquerade, published-port DNAT, and the host/none contrast.

The creation record preserves the explicit source-over-folklore corrections that current Moby can create the veth peer directly in the target netns (with a move-later fallback), and that normal port publishing is firewall DNAT/forwarding with `docker-proxy` used only when required by specific mappings/configuration.

## Lesson 33 clarity-rebuild record

After the learner reported that the first Lesson 33 version was not clear, Lesson 33 was rebuilt without changing its pinned technical baseline or lesson scope. The revision now starts with one concrete `docker run -p 18080:80` container and constructs the finished topology before introducing OCI/runtime implementation details. It separates four jobs explicitly—network namespace selection, veth cross-namespace transport, Linux bridge Layer-2 switching, and host Layer-3 forwarding/netfilter—and then traces two packets: same-bridge/container traffic versus Internet-bound traffic. Published-port DNAT is introduced only after outbound forwarding/SNAT is clear, so source NAT and destination NAT are not conflated. The exact `NewTask → initializeCreatedTask → Task.Start` handoff and current Moby veth direct-placement/fallback behavior remain in a second-read implementation section. Lesson 33 remains **created; awaiting study**.

## Continuity exception — Lesson 32 status

The learner explicitly instructed the course to continue from Lesson 33 before Lesson 32 had been marked studied in the transfer bundle. That instruction authorized Lesson 33 creation only. Lesson 32 remains **created; awaiting study**. Do not silently infer Lesson 32 study completion from Lesson 33's existence.

## Lesson 34 creation record

Lesson 34 was created on 2026-08-07 after reading the continuity/reference files, reviewing Lesson 33's libnetwork and bridge foundations, reporting the required research checkpoint, and receiving explicit learner approval to proceed. The lesson is built against Moby 29.6.2 and matching Linux 6.18 networking documentation/source. It separates two relationships that are often blurred: the network driver chooses how a Docker endpoint is represented by Linux networking objects, while Docker's embedded DNS is a separate libnetwork sandbox service. The lesson covers one-Linux-bridge-per-user-defined-bridge behavior, per-network service-name records, the `127.0.0.11` resolver path and its current ephemeral-port NAT implementation, macvlan parent/child attachment, and IPvlan L2/L3/L3S behavior.

The creation pass also corrected the research-checkpoint wording about published ports on macvlan/ipvlan. In Moby 29.6.2 those drivers label port mapping unsupported and log a warning when mappings are supplied; their `CreateEndpoint` functions do not reject the endpoint solely because a port mapping was present. The pinned implementation, not the earlier shorthand, governs the lesson.

Lesson 34 remains **created; awaiting study**. Lessons 32 and 33 also remain **created; awaiting study**; Lesson 34's creation does not imply either was completed.

## Continuity exception — Lesson 34 creation

The learner explicitly requested the next lesson and then approved Lesson 34 creation while Lessons 32 and 33 remained recorded as awaiting study. That instruction authorized Lesson 34 creation only. Do not silently infer study completion for Lessons 32 or 33.

## Handoff for the next lesson

After Lesson 34 is studied and the learner requests Lesson 35: read the reference files, review the runtime/task and PID 1 foundations needed for stdio/logging, inspect the pinned Moby, containerd, runc, and relevant Linux sources for stdio attachment, FIFOs/pipes/PTY behavior, log-driver handoff, and container log lifecycle, report 3–5 findings, then wait for direction according to the established one-lesson workflow. Preserve the recorded Lessons 32 and 33 awaiting-study statuses unless the learner explicitly studies or resolves them.

## Lesson 33 targeted libnetwork clarification record

After the learner pointed out that Lesson 33 used `libnetwork` without introducing it, the lesson was corrected in-place rather than expanded into a separate lesson. The new section appears before the runtime/networking handoff relies on the term. It establishes that libnetwork is an Engine-internal Go subsystem owned by `dockerd`, introduces the source-defined `Controller`, `Network`, `Endpoint`, and `Sandbox` objects, and explicitly distinguishes those control-plane objects from the Linux netns, veth, bridge, routing, and netfilter objects that implement packet flow. The pinned Moby 29.6.2 baseline is unchanged. Lesson 33 remains **created; awaiting study**.

## Lesson 33 second clarity rebuild — simplified first pass

On 2026-08-07 the learner requested another Lesson 33 rebuild because the technically complete version still required too many mechanisms to be held in memory at once. The lesson was rewritten again without changing scope, pinned versions, or technical conclusions. The new version uses two passes: Sections 1–7 build one bridge topology and trace three packet classes (same-bridge, outbound Internet, and inbound published-port traffic); Sections 8–9 then prove the exact OCI/Moby/runc creation order and current Moby veth direct-placement/fallback behavior. The rebuild explicitly keeps libnetwork control objects separate from Linux kernel objects, and makes the source-vs-destination NAT distinction central. Lesson 33 remains **created; awaiting study**; no study completion is inferred for Lesson 32 or Lesson 34.


## 2026-08-07 Lesson 33 visual-mechanism rebuild decision

At learner request, Lesson 33 was rebuilt a third time for comprehension without reducing technical depth. The approved teaching adjustment is: when a networking mechanism is load-bearing, show the packet problem and the packet/header action before introducing the mechanism name. Small diagrams or lightweight animation are preferred when they make packet direction, namespace boundaries, routing, or NAT rewrites materially easier to see. The source-level OCI/Moby/runc explanation remains a second read. Lesson 33 remains **created; awaiting study**; no study status was inferred.


## 2026-08-07 Lesson 33 foundation-first rebuild decision

After the learner reported that Lesson 33 still assumed too much networking vocabulary, Lesson 33 was rebuilt again without changing scope or pinned technical facts. The new rule is stronger than the earlier “problem before term” rule: every load-bearing networking concept must identify **who configures it, who executes it for a live packet, what object is acted on, and what changes** before introducing shorthand terminology. The rebuild explicitly defines interface, veth, Linux bridge, gateway, host output interface, IP forwarding, netfilter, iptables/nftables, SNAT/MASQUERADE, DNAT, and conntrack/NAT state just in time. It also makes the control-plane/data-plane split explicit: dockerd/libnetwork configures topology/rules; the Linux kernel executes packet movement and rewrites. Small packet animations remain, but each diagram contains only one mechanism. Lesson 33 remains **created; awaiting study**.


## 2026-08-07 Lesson 33 diagram-first rebuild decision

At learner request, Lesson 33 was rebuilt again for comprehension without changing scope, pinned sources, or technical conclusions. The approved teaching adjustment is now explicit: packet-spatial mechanisms are shown with standalone inline-SVG drawings before prose; diagrams are never placed beside explanatory text. Each prose section then identifies who configures the mechanism, who executes it for a live packet, what object is acted on, and what changes. The rebuild separately visualizes netns isolation, libnetwork-vs-kernel ownership, bridge topology, same-subnet switching, route/gateway/ARP selection, bridge local delivery, host IP forwarding, netfilter rule ownership, SNAT/MASQUERADE including reply mapping, published-port DNAT, network modes, startup ordering, and current Moby veth placement. Lesson 33 remains created; awaiting study.


## Lesson 33 depth-plus-diagrams rebuild record

After the learner reported that the diagram-first Lesson 33 had improved visualization but still compressed too much explanatory depth, Lesson 33 was rebuilt again on 2026-08-07. The revision restores the deeper foundation-first mechanism explanations while retaining standalone drawn diagrams. A strict first-use rule is now recorded for this lesson: every newly introduced networking term must be defined before subsequent prose depends on it, and each mechanism must name the configuration-time actor, packet-time actor, object acted on, and exact packet/topology change. No pinned technical baseline or lesson scope changed. Lesson 33 remains **created; awaiting study**.


## Lesson 36 source-aligned rebuild record — 2026-08-08

Lesson 36 was rebuilt after the learner explicitly asked for the teaching method to be followed exactly. Before drafting, the course map, progress record, source baseline/correction register, HTML style guide, and prerequisite lessons were reread. The first Lesson 36 draft was rejected as authoritative because it silently drifted from the course's Moby/Docker Engine 29.6.2 baseline to 29.7.2.

The rebuild uses Moby/Docker CLI 29.6.2 and OCI runtime-spec 1.3.0. Because the transfer's Engine baseline does not pin Docker Compose, Compose-specific implementation is independently pinned to Docker Compose v5.1.4 and its exact compose-go v2.11.0 dependency rather than altering the Engine family. The PostgreSQL `_FILE` example is anchored to docker-library/postgres commit `4f9ced0`, and the Linux process-environment boundary uses man-pages 6.18.

Teaching structure follows the approved method: one governing relationship (where the configuration bytes actually travel), execution order and actor ownership, one load-bearing diagram, compact source excerpts with exact anchors, explicit source-over-folklore corrections, and Linux/Docker experiments. The lesson cross-references rather than reteaches Lesson 3 (client vs daemon paths), Lesson 21 (OCI `process.env`), Lesson 30 (`ENV` image defaults/build-secret distinction), and Lesson 32 (bind-mount mechanics).

No lesson was marked studied by this rebuild. Lesson 35 was not modified; its baseline drift is recorded separately for a targeted correction rather than silently rewriting completed work.


## 2026-08-08 dense-deep compact lesson-format decision

At learner request, Lessons 35 and 36 were rebuilt to reduce study length without reducing mechanism depth. The approved compression rule is: **remove repetition, not causal steps**. Each load-bearing relationship is explained once in full execution order; later sections cross-reference it rather than rebuilding it. Keep every relevant actor boundary, source-supported edge case, source-over-folklore correction, and inspect-it-yourself observation. Use at most one load-bearing diagram when it materially reduces working-memory load, and keep exact audit anchors in a collapsed source appendix.

Lesson 35's compact rebuild also resolves its previously recorded baseline drift: the 29.7.2 continuation draft is superseded by a rebuild against the authoritative Moby 29.6.2 / containerd 2.2.6 / runc 1.3.6 / OCI runtime-spec 1.3.0 family. Lesson 36 remains aligned to Moby/Docker CLI 29.6.2 / OCI runtime-spec 1.3.0 with Compose v5.1.4 / compose-go v2.11.0 pinned independently. Neither lesson is marked studied by the rebuild.

## 2026-08-08 clear-deep readability decision for Lessons 35–36

After the learner found the dense-deep compact versions of Lessons 35 and 36 difficult to read, both lessons were rebuilt again without changing their technical baselines or approved scope. The compact-format rule is superseded where it harms comprehension. The new learner-facing rule is **clear-deep**: make the problem and execution path understandable before presenting implementation identifiers; define every new term before later prose depends on it; follow one byte/value through the responsible components in real execution order; keep source function/file names as proof after the mechanism is clear; and preserve source-supported edge cases and corrections even when they require additional prose.

Learner-facing component terminology is also standardized: say **Docker CLI**, **dockerd**, **containerd**, **runc**, **Compose**, or **Linux kernel** according to the responsible component. Do not use the Docker Engine source repository's project name as if it were a runtime component. That repository identifier may appear only implicitly in source URLs or when exact provenance is required in an audit appendix. This is a terminology/pedagogy decision, not a technical-source change.

Lesson 35 remains pinned to Docker Engine 29.6.2 / containerd 2.2.6 / runc 1.3.6 / OCI runtime-spec 1.3.0. Lesson 36 remains pinned to Docker Engine/Docker CLI 29.6.2 / OCI runtime-spec 1.3.0, with Compose v5.1.4 / compose-go v2.11.0 pinned independently. Neither lesson is marked studied by this readability rebuild.

## 2026-08-08 pipeline-first movement teaching decision

After the learner identified that Docker mechanisms become easier to understand when the lesson shows **how an object moves through the Docker stack**, Lessons 35 and 36 were rebuilt again without changing their technical scope or pinned source baselines. This supersedes any presentation choice in the earlier compact rebuild that obscures movement.

For future multi-component mechanisms, use a **pipeline-first clear-deep** teaching structure:

1. Start with one whole-path diagram or compact flow that shows the responsible components in execution order.
2. Explicitly state **what is moving** at each hop: bytes, API fields, environment strings, mount descriptions, secret bytes, packets, file descriptors, OCI fields, etc.
3. For each hop, explain **who handles it, where it is now, and what changes** before introducing source-level function or structure names.
4. Then zoom into each hop in order. Do not explain components as disconnected facts.
5. Keep exact source anchors after the mechanism is already understandable; source identifiers support the explanation rather than replacing it.
6. Preserve all relevant source-supported edge cases and corrections. Pipeline-first is a comprehension rule, not a depth reduction.
7. Learner-facing component names remain **Docker CLI, dockerd, containerd, shim, runc, Compose, Linux kernel**, etc. The Docker Engine repository project name is not used as if it were a runtime component.

The current Lesson 35 teaches the output path as: process `write(2)` → stdout/stderr → containerd/shim task I/O → dockerd stream distribution → attach path and/or log-record path → logging driver / client. The current Lesson 36 teaches configuration as separate travel pipelines: Docker CLI env → `Config.Env` → OCI `process.env` → process; Compose `.env` → Compose interpolation; local file secret → read-only bind mount → `/run/secrets`; Swarm secret → worker dockerd tmpfs staging → read-only task mount. Neither lesson is marked studied by this rebuild.



## Lesson 37 creation record — 2026-08-08

Lesson 37 was created after reading the handoff/reference files and prerequisite runtime lessons, then inspecting the pinned primary sources before drafting. It uses the approved pipeline-first clear-deep method and keeps the four mechanisms separate by ownership: health-state monitoring in `dockerd`, restart decisions in `dockerd`, resource enforcement in Linux cgroups, and process credentials in the Linux kernel.

Pinned implementation family: Docker Engine/Docker CLI 29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, OCI image-spec 1.1.1, Linux 6.18. runc 1.3.6's own `go.mod` pins `opencontainers/cgroups v0.0.4`, so cgroup-v2 file-writing anchors use that dependency rather than obsolete runc-internal cgroup paths.

Source-over-folklore corrections retained in the lesson:

1. Health status and restart policy are separate state machines; becoming `unhealthy` does not itself restart a running container.
2. The 10-second restart-manager threshold resets exponential backoff after a stable run; it is not a minimum runtime required before restart policy becomes active.
3. `--memory-reservation` maps to cgroup-v2 `memory.low`, which is best-effort reclaim protection rather than a soft maximum.
4. `--cpus` and `--cpu-shares` terminate in different CPU-controller mechanisms (`cpu.max` bandwidth quota versus relative `cpu.weight`).
5. `USER` / `--user` becomes numeric OCI `process.user` and then Linux credentials; it does not itself create a user namespace.

Lesson 37 remains **created; awaiting study**. No prerequisite lesson was marked studied by its creation.


## 2026-08-08 cumulative handoff bundle delivery decision

At learner request, every newly created lesson should be delivered in two forms: the standalone lesson HTML and a refreshed cumulative handoff ZIP through that lesson. The refreshed bundle must include the new lesson and advance only the continuity/reference files that legitimately changed (course map, progress/decisions, source record, correction log, and next-chat instructions). It must preserve earlier lesson files and recorded study status unless the learner explicitly changes them.


## Lesson 38 creation record — 2026-08-08

Lesson 38 was created after rereading the handoff/reference files and the prerequisite runtime lessons, then inspecting Docker CLI/Engine 29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, and CRIU primary source before drafting. Because CRIU is an external dependency rather than part of the Engine-pinned component family, CRIU internals were independently pinned for this lesson to **CRIU v4.2.1** (tagged 2026-07-21); this does not change the global Engine/runtime baseline.

The lesson uses the approved movement-first pipeline twice: checkpoint follows a request downward until CRIU turns live process/kernel state into checkpoint files; restore follows the existing Docker container/rootfs plus those checkpoint files downward until CRIU reconstructs live kernel objects and restores userspace execution context. It deliberately keeps the Docker rootfs/configuration separate from CRIU checkpoint files.

Source-level corrections recorded in the lesson:

- A Docker checkpoint is not a Docker/OCI image and not a complete rootfs snapshot; it stores CRIU runtime-state files while the existing container configuration/rootfs remain separate restore inputs.
- Docker CLI 29.6.2 maps the default checkpoint to `Exit=true`; `--leave-running` becomes `Exit=false`, which is translated down to runc/CRIU leave-running behavior.
- Restore is not “wake the old PID.” `dockerd` performs normal start preparation; containerd's shim stages `runc.RestoreOpts` during task create and calls runc restore during task start; CRIU then reconstructs live process/kernel state.
- OCI runtime-spec 1.3.0 does not standardize checkpoint/restore lifecycle operations; this is an implementation extension across Docker/containerd/runc/CRIU.
- Docker Engine 29.6.2 explicitly gates checkpoint restore behind experimental mode and its start path rejects a custom checkpoint directory even though the CLI exposes `--checkpoint-dir`. runc 1.3.6 also warns that checkpoint/restore is untested with rootless containers.

Lesson 38 remains **created; awaiting study**. Lessons 32–37 remain in their previously recorded awaiting-study state; creating Lesson 38 does not infer study completion.


## Lesson 39 creation record — 2026-08-08

Lesson 39 was created after rereading the Lesson-38 handoff/reference files, reviewing the image/distribution prerequisites in Lessons 18, 19, 20, 22, and the pull stage of Lesson 23, and inspecting the pinned OCI distribution-spec v1.1.1 plus Docker CLI/Engine 29.6.2 and containerd v2.2.6 registry client source. The lesson follows two movement pipelines: pull moves a reference to a resolved descriptor and then recursively moves manifest/index/config/layer bytes from registry HTTP endpoints into containerd's content store before Engine-requested unpack; push walks the local descriptor graph and makes child blobs available before committing manifests/indexes.

Source-level corrections recorded by the lesson: OCI registry authentication is outside the distribution-spec contract; only the Pull conformance category is mandatory; containerd v2.2.6 normally resolves a tagged manifest with HEAD and falls back to GET when digest/size headers are insufficient; OCI distribution-spec v1.1.1 defines chunked PATCH uploads, but the pinned containerd Docker-registry pusher uses a monolithic POST-then-PUT path and still carries `TODO: Support chunked upload`; and containerd's push walker explicitly uploads parents after children.

Lesson 39 is **created; awaiting study**. Lessons 32–38 retain their recorded awaiting-study status. The next approved course slot is Lesson 40 — Tags vs digests, content-addressed transfer & dedup.


## 2026-08-09 — Lesson 39 clarity/scope rebuild

After the learner reported that Lesson 39 was complicated and introduced terms without a later teaching payoff, Lesson 39 was rebuilt without changing its pinned source baseline or core technical conclusions. The learner-facing rule is now stricter: every term introduced in the main path must either be defined immediately and used in the current mechanism, or be deferred to the lesson that owns it.

The main Lesson 39 path now follows one object at a time: image reference/control request → root descriptor resolution → manifest/index JSON → child descriptors → config/layer blob bytes → containerd content store/unpack; push reverses the graph with child content available before parent manifests/indexes. Cross-repository mount/dedup is deferred to Lesson 40; referrers/signing/provenance is deferred to Lesson 41; deletion/content-discovery/conformance catalog material is removed from the learner-facing path. OCI chunked upload remains only as a self-contained spec-completeness branch because the selected Distribution Spec defines it, while pinned containerd 2.2.6 uses the monolithic POST→PUT path.

Lesson 39 remains **created; awaiting study**. No prerequisite lesson is inferred studied.


## Lesson 38 second clarity rebuild — 2026-08-09

The learner reported that the first clarity rewrite of Lesson 38 was still not explained well. This was treated as a teaching-structure problem, not a source-baseline change.

- Rebuilt Lesson 38 around one concrete running-process example: an in-memory counter, a saved instruction position/register context, and an open file descriptor.
- The lesson now establishes the exact missing-state problem before introducing CRIU vocabulary: rootfs state versus live memory/CPU/kernel-resource state.
- New terms are defined before use: live execution state, checkpoint, CRIU image files, restore, parasite, and restorer blob.
- Checkpoint is taught once in real execution order: Docker CLI → dockerd → containerd → shim → runc → CRIU → Linux kernel/process state → checkpoint files.
- Restore is taught once as a two-input reconstruction: existing container environment + CRIU files → containerd/shim restore state → runc → CRIU → new live kernel objects.
- The `rt_sigreturn` relationship is now explained causally: restored memory alone is insufficient; CRIU must also reinstall the saved register context, including the saved instruction and stack pointers, so execution continues rather than re-enters program startup.
- Optional/internal terminology no longer appears before its purpose. CRIU's parasite is defined only at the memory-copy step; the restorer blob is defined only at the final-memory/register restoration step.
- Technical baseline and corrections remain unchanged: Docker Engine/Docker CLI 29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, Linux 6.18 boundary, CRIU v4.2.1 lesson pin.
- Lesson 38 remains **created; awaiting study**. No other lesson study status changes.


## Lesson 40 creation record — 2026-08-09

Lesson 40 was created by explicit learner instruction after rereading the cumulative handoff/reference files, reviewing Lessons 18, 19, 20, 22, and 39, and inspecting the pinned OCI image-spec v1.1.1, OCI distribution-spec v1.1.1, Docker CLI/Engine 29.6.2, and containerd v2.2.6 source before drafting. The learner prompt called Lesson 20 the content-store/leases prerequisite; the authoritative course map identifies Lesson 20 as OCI image layout and Lesson 22 as Content store & GC / leases, so both were reviewed and the discrepancy was reported rather than silently changing the course map.

The lesson uses one persistent example graph and one digest-driven movement loop: repository tag → registry resolution → root descriptor → per-descriptor local digest check → fetch only if missing → hash and verify incoming bytes → commit to the digest-derived content-store path → follow child descriptors. Push is taught as the corresponding remote decision: exact-content HEAD → skip payload when present → cross-repository mount when a source candidate is known → upload fallback when needed.

Source-level corrections/precision points retained in Lesson 40:

1. A tag is a repository-level human-readable pointer to a manifest in OCI Distribution terminology; the root can be an OCI image manifest or image index. Tag resolution returns/constructs a descriptor whose digest identifies the root bytes.
2. Pull dedup in containerd happens before the registry body fetch for an already-local descriptor: `Fetch` opens a writer with the expected descriptor first, and the local store returns `ErrAlreadyExists` when `blobPath(expected)` exists.
3. Digest lookup and digest verification are distinct steps using the same expected identifier. Incoming bytes are hashed during ingest; `Commit` rejects an actual-vs-expected digest mismatch before moving the ingest file into its final digest-derived path.
4. Push dedup is an explicit remote existence check. The pinned pusher returns `ErrAlreadyExists` for matching remote content, and the higher push handler returns before `provider.ReaderAt` opens the local payload.
5. Cross-repository blob mounting is in Lesson 40 scope: OCI Distribution v1.1.1 defines `POST ...?mount=<digest>&from=<other_name>`; a successful `201 Created` avoids client blob upload, while an unsuccessful/not-completed mount falls back to ordinary upload. On the pinned Engine path, dockerd's `findMissingMountable`/`canBeMounted` select eligible same-registry blob candidates from recorded distribution-source metadata; containerd's pusher then issues the mount request.
6. Transfer dedup is exact-byte/content-digest dedup, not semantic filesystem equivalence. Two stored layer representations with different descriptor digests remain different registry/content-store objects even if their uncompressed effects are equivalent.
7. Dedup does not imply zero network traffic: mutable tag resolution still performs registry metadata traffic, and creating another tag can require a manifest/index PUT even when child blobs are already remote.

Lesson 40 is **created; awaiting study**. Lessons 32–39 retain their previously recorded awaiting-study state. The next approved course slot is Lesson 41 — Image signing & provenance.


## Lesson 40 second clarity rebuild — 2026-08-09

The learner reported that the first Lesson 40 build was not explained well. The primary sources were rechecked and did not require a technical correction or source-baseline change. The problem was teaching order and working-memory load.

The canonical Lesson 40 was rebuilt with these decisions:

1. Start with **one tag and one single-platform root manifest**. Do not begin with two tags plus an index plus a platform manifest plus child blobs simultaneously.
2. Establish the exact transition `repository:tag → registry manifests lookup → Descriptor{Digest, Size, MediaType}` before discussing dedup. Explicitly state that the tag string is not hashed to obtain the root digest.
3. Follow **one descriptor** through the pull loop before expanding to the whole graph: expected digest → local digest-derived path check → local hit skips body fetch / local miss fetches bytes → hash during ingest → commit compares actual vs expected → verified content moves to its final digest-derived path.
4. Keep the digest's jobs temporally separate: content identity, local lookup, transfer verification, final address, and remote push existence. Never compress these into a vague “hashing/dedup” explanation.
5. Only after the single-object loop is understood, expand to shared config/layer digests and explain an image index as one extra descriptor hop rather than making it the starting example.
6. Push dedup and cross-repository mount remain in scope, but appear after pull-side identity/reuse is established. Cross-repository mount keeps the precise ownership split: dockerd prepares eligible same-registry source candidates; containerd issues the registry mount request.
7. Exact descriptor-digest equality remains the transfer-dedup boundary; tag-resolution metadata can still move, and a new tag can still require a root manifest/index PUT.

Lesson 40 remains **created; awaiting study**. No other lesson's study status changes. Lesson 41 remains the next approved course slot.


## Lesson 41 creation record — 2026-08-09

Lesson 41 was created after the learner explicitly requested the next lesson while Lessons 32–40 remain recorded as awaiting study. This creation does not imply any study completion.

Canonical teaching order for Lesson 41:

1. Keep provenance and signatures separate: provenance is build evidence/claims; a signature is cryptographic evidence from an accepted signing key/identity.
2. BuildKit provenance pipeline first: solved build graph → `captureProvenance` → in-toto statement whose subject is the exact platform image-manifest digest → content-addressed provenance payload → attestation manifest → root image index.
3. Only after BuildKit has attached provenance, introduce signing of the final published root digest. The signature is not placed inside the signed root; it is stored as a separate referring artifact.
4. OCI `subject` / Distribution referrers are attachment/discovery relationships, not trust. Verification must separately validate cryptography and confirm that the verified signed subject digest equals the image digest being verified.
5. Docker CLI 29 removed the old built-in Docker Content Trust commands, so Lesson 41 does not teach `docker trust sign` as the current pinned Docker path. Cosign **v3.0.6** is independently pinned for the external signing/verification implementation without changing the Docker/BuildKit/containerd/OCI baseline.

Source-over-folklore corrections recorded by Lesson 41: BuildKit provenance generation is not itself image signing; a mutable tag is not the cryptographic signing identity; an OCI referrer association does not establish signer trust; a valid signature for an old digest does not follow a tag to a new digest; and signing the final root digest transitively binds the descriptor graph but does not by itself prove the factual truth of provenance claims.

Status: Lesson 41 is **created; awaiting study**. Lessons 32–40 remain awaiting study. Lesson 42 is the next planned lesson.


## Lesson 42 creation record — 2026-08-09

Lesson 42 was created by explicit learner instruction after rereading the cumulative continuity/reference files, reviewing only the earlier lessons needed for Compose's model/API boundary, and inspecting the pinned parent Docker CLI/Engine 29.6.2 plus independently pinned Docker Compose v5.1.4 / compose-go v2.11.0 sources before drafting. Lessons 32–41 remain recorded as awaiting study; creating Lesson 42 does not infer any study completion.

Canonical Lesson 42 teaching order:

1. Establish the complete path first: `docker compose up` → parent Docker CLI plugin dispatch → Compose/compose-go file loading → resolved `Project` model → Compose labels and Engine resource names → Engine API create/reconcile → dependency-ordered start → the existing Lesson 23 container runtime chain.
2. Make the ownership boundary explicit: Compose is a client-side loader/reconciler. It does not replace dockerd, containerd, shim, runc, or the Linux kernel.
3. Use one `shop` application throughout: `web`, `db`, one named volume, and one explicit network. Follow the same objects from YAML to the `Project` model to Engine networks/volumes/containers.
4. Teach identity from exact implementation: project-name precedence, derived resource names, and `com.docker.compose.*` labels used to rediscover existing Engine objects.
5. Teach convergence rather than command folklore: `up` has a create/reconcile phase followed by start; services can converge to multiple containers; a rerun can reuse/recreate/scale; `down` identifies labeled project resources and retains declared named volumes unless volume removal is explicitly requested.
6. Teach `depends_on` precisely: short syntax normalizes to `service_started`, which supplies dependency ordering but not application readiness; `service_healthy` adds the explicit health wait.

Pinned source/version record for Lesson 42:

- Parent Docker CLI / Docker Engine: **29.6.2**.
- Docker Compose plugin: **v5.1.4**.
- compose-go: **v2.11.0**.
- Compose v5.1.4's own `go.mod` embeds Docker CLI library **v29.5.1**; this is the plugin's actual dependency graph and does not change the course's parent Docker CLI/Engine 29.6.2 pin.
- The handoff did not independently pin a prose Compose Specification revision. Lesson 42 therefore derives load-bearing behavior from the pinned Compose/compose-go implementation and uses specification language only where it agrees; no newer spec-only behavior is silently imported.

No earlier completed lesson required a technical correction during Lesson 42 research.

**Status:** Lesson 42 is **created; awaiting study**. Lesson 43 remains the next planned lesson.

## Lesson 42 clarity rebuild — 2026-08-09

The learner asked for Lesson 42 to be compacted in the same clear style as the prior lesson without losing source-backed depth. This is a teaching/structure rebuild, not a technical correction; the pinned source baseline and technical conclusions remain unchanged.

Canonical Lesson 42 teaching decisions after this rebuild:

1. Reduce the lesson from many isolated topic sections to one causal spine: **Compose files → resolved Project → names/labels → Engine networks/volumes/containers → convergence → dependency-aware start → repeated up/down**.
2. Keep one `shop` example only (`web`, `db`, `dbdata`, `appnet`) and carry it through every mechanism.
3. Define the central distinction early and reuse it: a **service is desired configuration + scale**, while containers are ordinary observed Engine objects.
4. Merge resource naming, implicit default-network behavior, named-volume mapping, and Compose labels into the points where they affect identity/reconciliation instead of teaching them as disconnected catalog items.
5. Preserve the exact pinned semantics that matter: create/reconcile before start; short `depends_on` = `service_started` ordering, not readiness; `service_healthy` performs the health wait; repeated `up` can reuse/recreate/scale; plain `down` retains declared named volumes and skips external resources.
6. Preserve the runtime boundary: Compose stops at the Docker Engine API; `dockerd → containerd → shim → runc → Linux kernel` remains the already-taught container runtime path.
7. Keep exact function/file anchors in compact prose and a collapsed source audit map instead of repeating source provenance in multiple sections.

**Status remains unchanged:** Lesson 42 is **created; awaiting study**. Lesson 43 remains the next planned lesson.



## Lesson 43 creation record — 2026-08-09

Lesson 43 was created after reading the cumulative handoff/reference files and the prerequisite runtime, networking, secrets, restart/resource, and Compose lessons, then inspecting the pinned Docker Engine/Docker CLI 29.6.2 source and its exact embedded SwarmKit dependency before drafting.

Pinned Swarm implementation: Docker Engine 29.6.2 `go.mod` requires `github.com/moby/swarmkit/v2 v2.1.3-0.20260609123145-f80b112cff7d`, resolved to commit `f80b112cff7d2fa4b67eff36f0bdd2cbd05be0d8`. This is lesson-specific implementation provenance inside the already-pinned Engine family, not a replacement of the course baseline.

Canonical compact teaching spine:

1. **Docker CLI → manager Engine API → Raft-backed Service desired state → orchestrator-created Tasks → scheduler sets Task.NodeID → dispatcher sends assignment/dependencies → worker executor creates an ordinary Docker container → Lesson 23 runtime pipeline.**
2. Keep **Service, Task, and container** distinct. A service is desired cluster state; a task is one execution attempt/slot; a worker container is the local runtime realization of an assigned task.
3. Raft replicates manager control-plane state. It does not run containers. Leader-only orchestrators/scheduler react to committed state.
4. Scheduler output is a placement decision recorded into the Task object; container creation happens later on the assigned worker.
5. Failure/restart/update create replacement Task objects rather than moving or resurrecting a live container.
6. Networking is a separate post-placement data-plane pipeline: Linux overlay realization uses bridge + VXLAN, while VIP load balancing is programmed through IPVS; the Linux kernel moves the live packets.
7. Close the Lesson 36 deferral: the dispatcher includes task dependencies and the worker reconciles secrets/configs before task state; worker-side secret staging remains the already-taught Lesson 36 mechanism.
8. Do not expand Lesson 43 into a Swarm command catalog or a full Raft algorithm course. Explain the implementation relationships needed to understand Docker's orchestration boundary.

No completed earlier lesson required a technical correction during Lesson 43 research. Lesson 36's explicit manager/Raft/distribution deferral is now fulfilled rather than modified.

**Status:** Lesson 43 is **created; awaiting study**. This status statement is historical; the learner subsequently approved and requested the merged final Lesson 44 described below.


## Final security merge and Lesson 44 creation record — 2026-08-09

The learner explicitly requested that the last three planned security lessons be compacted into one clear lesson without losing depth. This is an approved structural change, not an implicit redesign. The former planned topics were:

- 44 — Rootless Docker
- 45 — Plugins & authz
- 46 — Security capstone: `docker.sock = root`

They are now one final numbered lesson:

- **44 — Docker security boundary: rootless Docker, plugins/authz, and daemon-socket authority** — created; awaiting study.

The course therefore now contains **44 numbered lessons**. Former lesson numbers 45 and 46 are retired because their mechanisms were absorbed into Lesson 44; they are not missing lessons.

Canonical Lesson 44 teaching model:

1. Start from the Engine API pipeline: client → socket/transport → optional authz middleware → dockerd → ordinary container runtime chain.
2. Keep three security layers separate: workload sandbox, API authorization, daemon privilege boundary.
3. Rootless means the rootless launcher creates an unprivileged user/mount/network namespace environment through RootlessKit **before** executing dockerd. This differs from both a non-root container user (Lesson 37) and rootful userns-remap (Lesson 7).
4. The phrase `docker.sock = root` is explicitly scoped to a **rootful** daemon. The socket is an Engine API authority endpoint; the root-level consequence comes from the host-root dockerd behind it and the host-sensitive operations exposed by Engine `HostConfig`. A rootless socket remains high authority over that user's rootless daemon but is bounded by the daemon's outer host privileges.
5. Authorization plugins are Engine API middleware. `AuthZRequest` runs before the real handler, `AuthZResponse` after it; all configured plugins must allow. This is policy delegation, not a container sandbox and not a privilege drop for dockerd.
6. The plugin adapter resolves configured authorization plugin code and calls its request/response authorization endpoints; policy therefore introduces another trusted component.
7. Lesson 44 ends at the Docker/Linux boundary and does not expand into general kernel-security internals.

No completed earlier lesson required a technical correction during this merge. The new lesson cross-references Lessons 7, 11–13, 23, and 37 instead of re-teaching them.

**Status:** Lesson 44 is **created; awaiting study**. The numbered Docker internals course is now structurally complete.
