# Source baseline and correction register

Status date: **2026-08-09**

## Coherent baseline for continued work

Start future research from this release family rather than mixing repository `main` branches:

| Component | Pinned baseline | Role |
|---|---:|---|
| Docker Engine / Moby | **29.6.2** | Top-level release baseline |
| BuildKit | **v0.31.1** | Bundled builder line in Engine 29.6.x |
| containerd | **v2.2.6** | Bundled task/content/snapshot runtime line in Engine 29.6.x |
| runc | **v1.3.6** | Bundled OCI runtime line in Engine 29.6.x |
| OCI Runtime Specification | **v1.3.0** | Runtime bundle/config/lifecycle contract |
| OCI Image Specification | **v1.1.1** | Image descriptors, manifests, config, layers, layout |
| OCI Distribution Specification | **v1.1.1** | Registry HTTP API contract |
| Linux userspace API docs | **man-pages 6.18** plus matching kernel docs/source when needed | Kernel boundary |

For each lesson, record exact tag/commit and path. If Docker Engine vendors or pins a different revision, the Engine release's dependency graph wins. Never mix a current `main` file with an older release explanation without saying so.

Lesson-specific external pin for Lesson 41: **Cosign v3.0.6**. Docker Engine does not vendor Cosign; this pin is local to the lesson and does not modify the coherent Docker/BuildKit/containerd/runc/OCI baseline.

Lesson-specific independently versioned Compose pin used by Lessons 36 and 42: **Docker Compose v5.1.4 / compose-go v2.11.0**. The parent Docker CLI / Docker Engine baseline remains **29.6.2**. Compose v5.1.4's own `go.mod` embeds Docker CLI library v29.5.1; this is recorded as the plugin's internal dependency, not as a course-baseline switch. The handoff does not separately pin a prose Compose Specification revision, so Lesson 42 treats the pinned implementation as normative for implementation-specific behavior and does not silently import newer spec semantics.

## Primary-source starting points

- Docker Engine release notes: `docs.docker.com/engine/release-notes/29/`
- Moby: `github.com/moby/moby`
- BuildKit: `github.com/moby/buildkit`
- containerd: `github.com/containerd/containerd`
- runc: `github.com/opencontainers/runc`
- OCI runtime-spec: `github.com/opencontainers/runtime-spec`
- OCI image-spec: `github.com/opencontainers/image-spec`
- OCI distribution-spec: `github.com/opencontainers/distribution-spec`
- Linux documentation/source: `kernel.org` and `man7.org`

## Lesson 29 source record

Lesson 29 was built against the pinned builder line and these exact implementation points:

- `moby/buildkit v0.31.1 · frontend/dockerui/config.go` — Dockerfile-first loading, Dockerfile-specific ignore-file precedence, `MainContext`, `FollowPaths`, and `ExcludePatterns`.
- `moby/buildkit v0.31.1 · frontend/dockerfile/dockerfile2llb/convert.go` — reachable-stage dispatch, `ctxPaths`, `normalizeContextPaths`, `filterPaths`, and per-instruction `COPY/ADD --exclude`.
- `moby/buildkit v0.31.1 · session/filesync/filesync.go` — client-side `fsutil.NewFilterFS` and the `diffcopy` filesystem-synchronization protocol.
- `moby/buildkit v0.31.1 · go.mod` — dependency pin to `github.com/moby/patternmatcher v0.6.1`.
- `moby/patternmatcher v0.6.1 · ignorefile/ignorefile.go` and `patternmatcher.go` — preprocessing, negation, ordered matching, and `**` behavior.
- Official Docker Build Context and Dockerfile references — supported context forms, remote-tar download location, named contexts, Dockerfile-specific ignore precedence, and local source-path confinement.

The lesson records the source-over-folklore correction that modern BuildKit does not necessarily send one unconditional tar archive of the whole context. The frontend can derive required paths from reachable local `COPY`/`ADD` operations, combine them with ignore patterns, and synchronize the filtered source through the build session.


## Lesson 30 source record

Lesson 30 was built against the pinned builder/image-spec line and these exact implementation points:

- `moby/buildkit v0.31.1 · frontend/dockerfile/dockerfile2llb/convert.go · dispatchArg` — build-argument resolution, current LLB-state environment, stage tracking, and `ARG KEY=value` history creation.
- `moby/buildkit v0.31.1 · frontend/dockerfile/dockerfile2llb/convert.go · dispatchEnv` — current-state update plus `image.Config.Env` mutation and metadata-only history.
- `moby/buildkit v0.31.1 · frontend/dockerfile/dockerfile2llb/convert.go · runCommandString / commitToHistory` — resolved build arguments recorded with `RUN` history entries.
- `moby/buildkit v0.31.1 · dispatch-state initialization` — child stages inherit parent stage state, image config, and tracked build arguments.
- `moby/buildkit v0.31.1 · solver/llbsolver/provenance.go` — maximal/minimal provenance boundary, `build-arg:` scrubbing in minimal mode, and secret ID/optionality capture without payload capture.
- `opencontainers/image-spec v1.1.1 · config.md` — `config.Env` runtime defaults, `history.created_by`, and `empty_layer` semantics.
- Official Docker Build Variables and Build Secrets references — stage scoping, proxy-argument exception, and temporary secret/SSH mounts.

The lesson records the source-over-folklore correction that “build-only” does not mean “secret” or “unrecorded.” An ordinary `ARG` does not automatically enter `image.Config.Env`, but its resolved value can appear in image history and fuller provenance and can permanently affect filesystem/configuration output. `ENV` deliberately writes the value into the output image configuration.


## Lesson 31 source record

Lesson 31 was built against the pinned builder/image-spec line and these exact implementation points:

- `moby/buildkit v0.31.1 · solver/cachekey.go` — operation cache keys and dependency cache-key relationships.
- `moby/buildkit v0.31.1 · solver/llbsolver/ops/exec.go · ExecOp.CacheMap` — execution-operation definition, platform, mounts, selectors, and input dependency identities.
- `moby/buildkit v0.31.1 · solver/llbsolver/ops/file.go` — file-operation selectors and content-hash functions used by `COPY`.
- `moby/buildkit v0.31.1 · cache/contenthash/filehash.go · NewFileHash / v1TarHeaderSelect` — file contents and relevant metadata included in checksums while mtime is omitted from the selected v1 header.
- `opencontainers/image-spec v1.1.1 · layer.md` — layer changesets, `.wh.<name>` deletion markers, and the fact that a later whiteout does not rewrite an earlier blob.
- `moby/buildkit v0.31.1 · frontend/dockerfile/dockerfile2llb/convert_runmount.go` — `RUN --mount=type=cache`, persistent cache IDs, and `shared`/`private`/`locked` mapping.
- `moby/buildkit v0.31.1 · solver/llbsolver/mounts/mount.go` — separate mutable cache references, retain policy, and concurrency behavior.
- Official Docker cache and Dockerfile references — `--no-cache`, cache invalidation guidance, and cache-mount user-facing contract.

The lesson records three source-over-folklore corrections: BuildKit caches graph operations and dependencies rather than line numbers in isolation; an unchanged network-fetch command does not become fresh merely because the remote server changed; and deleting a file in a later layer records a whiteout rather than removing the earlier layer bytes. It also distinguishes the ordinary operation-result cache from a `RUN` cache mount, which can accelerate an operation that still executes.


## Lesson 32 source record

Lesson 32 was built against the pinned Engine/runtime line and these exact implementation points:

- `opencontainers/runtime-spec v1.3.0 · config.md · POSIX-platform Mounts` — mount destination, source, filesystem type, options, and Linux bind/tmpfs examples.
- `moby/moby docker-v29.6.2 · daemon/volumes.go · registerMountPoints` — Docker bind/volume/tmpfs request handling, volume creation, driver-selected mountpoints, and bind-source creation policy.
- `moby/moby docker-v29.6.2 · daemon/volume/mounts/mounts.go · MountPoint.Setup/Cleanup` — asking a volume driver to mount storage, bind-path setup, mount references, and cleanup.
- `moby/moby docker-v29.6.2 · daemon/oci_linux.go · withMounts` — translation of tmpfs to an OCI tmpfs entry and resolved user storage paths to OCI bind mounts.
- `moby/moby docker-v29.6.2 · daemon/create_unix.go · populateVolumes/populateVolume` — Docker-specific initial population of a volume from an image directory during container creation.
- `moby/moby docker-v29.6.2 · daemon/volume/local/local.go` — local-driver `_data` path, mount/unmount accounting, and physical removal.
- `moby/moby docker-v29.6.2 · daemon/volume/service/service.go · Remove` — refusal to remove a still-referenced volume and pruning of unreferenced local volumes.
- `opencontainers/runc v1.3.6 · libcontainer/rootfs_linux.go · mountToRootfs` — low-level handling of `tmpfs` and `bind` mount entries.
- Official Docker bind-mount and container-run references — daemon-host path semantics, `--mount` versus `-v`, read-only behavior, and named/anonymous volume removal behavior.

The lesson records three source-over-folklore corrections: mounting over a destination covers rather than deletes image contents; a Docker volume is a daemon-managed object that is normally translated into a concrete OCI bind mount before runc sees it; and Docker volume population is a dockerd create-time copy operation, distinct from both ordinary mount behavior and OverlayFS copy-up.


## Lesson 33 source record

Lesson 33 was built against the pinned Engine/runtime/Linux line and these exact implementation points:

- `opencontainers/runtime-spec v1.3.0 · config-linux.md · Namespaces / Network Devices` — create-vs-join namespace semantics and the explicit higher-level boundary for device creation, IP assignment, routing, and DNS.
- `opencontainers/runc v1.3.6 · libcontainer/configs/namespaces_syscall.go · namespaceInfo / CloneFlags` — `NEWNET → CLONE_NEWNET` and omission of path-based namespace joins from new-namespace clone flags.
- `moby/moby docker-v29.6.2 · daemon/oci_linux.go · WithNamespaces` — ordinary private network namespace with no path, `container:<id>` path join, and host-mode namespace removal.
- `moby/moby docker-v29.6.2 · daemon/start.go · containerStart` and `daemon/start_linux.go · initializeCreatedTask` — `NewTask → initializeCreatedTask → Task.Start`, sandbox keying to `/proc/<pid>/ns/net`, then `allocateNetwork`.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/bridge/bridge_linux.go · CreateEndpoint / createVeth / addToBridge / Join` — veth creation, direct peer placement with `PeerNamespace`, move-later fallback contract, host-peer bridge attachment, and gateway handoff.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/osl/interface_linux.go · createInterface / moveLink` — moving the interface into the target netns when it was not created there and configuring it from the sandbox namespace.
- `Linux v6.18 · Documentation/networking/bridge.rst` and `Documentation/networking/ip-sysctl.rst` — Layer-2 bridge semantics and IPv4 forwarding semantics.
- `Linux man-pages 6.18 · network_namespaces(7) / veth(4)` — network-namespace resource isolation and veth-pair semantics at the kernel/userspace API boundary.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/bridge/setup_ip_forwarding.go` — IPv4 forwarding check/enable behavior and firewall default-forward-policy interaction.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/bridge/internal/nftabler/network.go` — bridge-network forwarding and outbound masquerade/SNAT rules.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/bridge/internal/iptabler/port.go · setPerPortNAT` and `internal/nftabler/port.go · setPerPortDNAT` — published-port destination NAT, separate forwarding permission, and the cross-family `docker-proxy` path.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/host/host.go` and `drivers/null/null.go` — built-in host/null drivers do not construct bridge/veth endpoint wiring.

The lesson records three source-over-folklore corrections: current Moby does not always create both veth peers in the host namespace before moving one; a Linux bridge is an L2 switch and must not be conflated with the host routing/forwarding/NAT machinery around it; and `docker-proxy` is conditional rather than the universal implementation of `-p` port publishing.

## Lesson 33 clarity-rebuild source note

The learner-requested Lesson 33 clarity rebuild on 2026-08-07 did **not** change the pinned technical baseline or add a new mechanism. The revision preserves the Lesson 33 source record above and changes teaching order only: finished packet topology first, then packet traces, then the OCI/Moby/runc creation path. The rebuild was rechecked against OCI runtime-spec v1.3.0 namespace semantics and Moby docker-v29.6.2 `WithNamespaces`, `containerStart` / `initializeCreatedTask`, bridge forwarding setup, and published-port DNAT paths.

## Lesson 34 source record

Lesson 34 was built against the pinned Engine/Linux line and these exact implementation points:

- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/bridge/bridge_linux.go · parseNetworkOptions / CreateNetwork / CreateEndpoint` — generated `br-<network-id-prefix>` names for non-default bridges, bridge-device creation, and endpoint realization on the per-network bridge.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/resolver.go · Resolver / SetupFunc / serveDNS / forwardExtDNS` — Docker's embedded DNS server, local Docker-name resolution, and forwarding of unresolved/external queries.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/sandbox_dns_unix.go · resolverIPSandbox / startResolver / rebuildDNS` — `127.0.0.11`, sandbox-scoped resolver startup, replacement of container nameservers with the embedded resolver, and the explicit legacy-default-bridge exception.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/resolver_unix.go · setupNAT` — current UDP/TCP ephemeral resolver sockets and DNAT/SNAT rules that present them to the container as `127.0.0.11:53`.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/sandbox.go · populateNetworkResources / ResolveName` and `daemon/libnetwork/network.go · addSvcRecords / ResolveName` — per-network service records and sandbox lookup across connected endpoints/networks.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/macvlan/macvlan_setup.go · createMacVlan`, `macvlan_joinleave.go · Join`, and `macvlan_endpoint.go · CreateEndpoint` — kernel macvlan child creation directly on a parent link, endpoint join behavior, generated endpoint MAC addresses, and unsupported-port-mapping warnings.
- `linux v6.18 · drivers/net/macvlan.c` — kernel-side MAC-based lookup/demultiplexing and bridge-mode delivery among macvlan ports.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/ipvlan/ipvlan_setup.go · createIPVlan / setIPVlanMode / setIPVlanFlag`, `ipvlan_joinleave.go · Join`, and `ipvlan_endpoint.go · CreateEndpoint` — parent-link IPvlan creation, L2/L3/L3S selection, L3/L3S route behavior, custom-MAC rejection, and unsupported-port-mapping warnings.
- `linux v6.18 · Documentation/networking/ipvlan.rst` — IPvlan's Layer-3 multiplexing/demultiplexing distinction from macvlan, shared Layer-2 identity, L2/L3/L3S modes, and L3S conntrack/iptables behavior.

The lesson records two source-over-folklore corrections. First, Docker's embedded DNS is a libnetwork sandbox resolver and is not a capability of the Linux bridge itself; the legacy default bridge explicitly has no internal nameserver. Second, the macvlan/ipvlan drivers mark Docker port mapping unsupported and warn when mappings are supplied; Moby 29.6.2 does not reject endpoint creation solely because the mapping was present.


## Lesson 39 source record

Lesson 39 was built against the pinned distribution/client line and these exact implementation points:

- `opencontainers/distribution-spec v1.1.1 · spec.md` — registry/repository/object vocabulary; Pull/Push/Content Discovery/Content Management conformance categories; `/v2/`; manifest and blob GET/HEAD; monolithic and chunked blob upload; cross-repository mount; manifest PUT; tag listing; referrers; deletion; status/error semantics.
- `docker/cli v29.6.2 · cli/command/image/pull.go` — client-side registry auth retrieval and Engine `ImagePull` request.
- `docker/cli v29.6.2 · cli/command/image/push.go` — client-side registry auth retrieval and Engine `ImagePush` request.
- Docker Engine source repository `moby/moby`, tag `docker-v29.6.2` · `daemon/containerd/image_pull.go` — resolver creation, `WithPullUnpack`, snapshotter selection, and `i.client.Pull`.
- Docker Engine source repository `moby/moby`, tag `docker-v29.6.2` · `daemon/containerd/image_push.go` — local target descriptor selection, resolver/pusher construction, and `remotes.PushContent`.
- `containerd v2.2.6 · client/pull.go::{Client.Pull,fetch}` — root reference resolution, fetcher acquisition, descriptor traversal, platform filtering, and content-store destination.
- `containerd v2.2.6 · core/remotes/docker/resolver.go::{NewResolver,Resolve}` — accepted manifest/index media types; HEAD-first tagged-reference resolution; `Docker-Content-Digest`/size/media-type descriptor construction; GET fallback when headers are insufficient.
- `containerd v2.2.6 · core/remotes/docker/fetcher.go::dockerFetcher.Fetch` — manifest/index GETs through `/manifests/<digest>` and config/layer/general blob GETs through `/blobs/<digest>`.
- `containerd v2.2.6 · core/remotes/handlers.go::{FetchHandler,PushContent}` — content-store fetch ingestion and child-before-parent push traversal; manifests deferred until children are handled and indexes pushed in reverse stack order.
- `containerd v2.2.6 · core/remotes/docker/pusher.go::dockerPusher.Push` — HEAD existence checks, cross-repository mounts, upload-session POST, Location handling including changed host/scheme authorization stripping, monolithic final PUT, manifest PUT, and the explicit `TODO: Support chunked upload`.
- `containerd v2.2.6 · core/remotes/docker/authorizer.go::{NewDockerAuthorizer,Authorize,AddResponses}` — Docker registry authentication challenge handling kept separate from the OCI distribution-spec contract.

The lesson records four source-over-folklore corrections: a Docker image is transferred as a descriptor graph rather than one opaque archive; OCI Distribution authentication is explicitly out of spec scope; an OCI-conforming registry is required to support Pull but not necessarily Push/Discovery/Management; and although OCI v1.1.1 defines PATCH-based chunked uploads, this pinned containerd registry pusher uses the monolithic POST→PUT path.

## Correction register

### CR-001 — stale lesson numbers

**Status:** applied.  
The syllabus expanded to 46 lessons after early lessons were written. References in Lessons 1–13 were repaired to the final numbering. This is navigation-only; the explanations were preserved.

### CR-002 — Lesson 2/5 shim ancestry and cardinality

**Status:** applied.  
A serving shim is not usefully modeled as a durable child of containerd. containerd bootstraps or locates it and controls it through runtime-v2 RPC. Its displayed PPID may be PID 1 or another subreaper. Runtime-v2 permits a shim per container or per runtime-defined group; one-per-container is common in Docker, not a universal interface rule.

### CR-003 — containerd bootstrap protocol version boundary

**Status:** applied as a source-baseline note in Lesson 5.  
Docker Engine 29.6.2 bundles containerd 2.2.6, whose runtime-v2 `start` path uses legacy flags/environment and returns JSON `BootstrapParams`. containerd 2.3+ introduces protobuf `BootstrapParams`/`BootstrapResult`. Future lessons must not silently mix those implementations.

### CR-004 — OCI hook guarantees

**Status:** applied to Lesson 14.  
At `createRuntime`/`createContainer`, hook authors may rely on the mount namespace and configured mounts, but must not assume cgroup placement or LSM labels are already active. `poststop` runs after OCI deletion and before `delete` returns.

### CR-005 — image-layer paths

**Status:** recorded; existing Lesson 17 already follows the spec.  
OCI layer archive entries are relative to the root filesystem (for example `./etc/...`), not absolute `/etc/...` member names. The original prompt's “absolute paths” wording is superseded by the Image Specification.

### CR-006 — Dockerfile completeness

**Status:** applied to Lesson 26.  
Parser directives (`# syntax`, `# escape`, `# check`) are not instructions and sit above the instruction categories. Deprecated `MAINTAINER` remains part of the accepted grammar and is documented as compatibility-only; prefer the OCI authors label.

### CR-007 — PID 1 precision

**Status:** applied to Lesson 28.  
The precise rule is about signal delivery to the init of a PID namespace, not a blanket statement that “PID 1 has no defaults.” Ordinary peer/ancestor signals are deliverable only when a handler exists; ancestor `SIGKILL`/`SIGSTOP` are forced. Shells generally fail to forward termination signals and are not guaranteed to be general init/subreaper processes. The common 10-second stop timeout is configurable.

## Open audits, not confirmed defects

- Lesson 29's BuildKit context path has been verified against BuildKit v0.31.1 and `moby/patternmatcher v0.6.1`. Future Dockerfile features must still be checked against the selected frontend syntax version.
- Before relying on any completed lesson's exact line/path, verify it against the pinned release and record a targeted correction if the path or implementation changed.

## Lesson 33 simplified-rebuild source note

The learner-requested second clarity rebuild on 2026-08-07 changes teaching order and prose only. The technical baseline remains Moby docker-v29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, and Linux 6.18. Before rewriting, the lifecycle and packet-path claims were rechecked against OCI namespace semantics; Moby `daemon/oci_linux.go · WithNamespaces`; `daemon/start.go` / `start_linux.go · initializeCreatedTask`; `daemon/libnetwork/drivers/bridge/bridge_linux.go · createVeth`; `setup_ip_forwarding.go`; and the published-port DNAT/forwarding path in `internal/iptabler/port.go`. No source-level correction was required.


## Lesson 33 visual-mechanism rebuild source note

The 2026-08-07 learner-requested visual-mechanism rebuild changes explanation order and visualization, not the pinned Docker/runtime facts. It retains the existing Lesson 33 Moby docker-v29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, and Linux 6.18 source record. The NAT explanation was additionally checked against Netfilter/nftables primary documentation: stateful NAT establishes a NAT binding from the first packet of a flow and applies the stored binding to later/reply packets; `masquerade` is a special source-NAT form that uses the outgoing interface's address. This clarification exists to explain the return path before introducing the SNAT/MASQUERADE terminology.


### Lesson 33 foundation-first source clarification — 2026-08-07

No pinned version changed. The learner-facing wording now distinguishes **configuration** from **execution**: Moby/libnetwork programs network topology and firewall/NAT policy, while Linux kernel bridge/IP/netfilter code executes the live packet path. Additional Linux 6.18 anchors used by the rebuild are `net/bridge/br_input.c::br_pass_frame_up`, `net/netfilter/nf_nat_masquerade.c::nf_nat_masquerade_ipv4`, and `net/netfilter/nf_nat_core.c::nf_nat_setup_info` / `nf_nat_packet`.


### Lesson 33 depth-plus-diagrams source note — 2026-08-07

No pinned version changed. The rebuild reuses the verified Moby docker-v29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, and Linux 6.18 baseline. Before finalizing, the core claims were rechecked against Moby `daemon/oci_linux.go::WithNamespaces`, `daemon/start_linux.go::initializeCreatedTask`, bridge veth setup, `setup_ip_forwarding.go`, `internal/iptabler/port.go::{setPerPortNAT,setPerPortForwarding}`, Linux `net/ipv4/arp.c::arp_process`, `net/bridge/br_input.c::br_pass_frame_up`, `Documentation/networking/ip-sysctl.rst::ip_forward`, and `net/netfilter/nf_nat_masquerade.c::nf_nat_masquerade_ipv4`. The change is pedagogical: definitions and diagrams were expanded; source-level conclusions did not change.


## Lesson 36 source record — 2026-08-08

Lesson 36 was rebuilt against the authoritative continued-work baseline rather than the superseded 29.7.2 draft. Exact anchors used:

- `docker/cli v29.6.2 · opts/parse.go · ReadKVEnvStrings` — client-side `--env-file` parsing and explicit `-e` override ordering.
- `docker/cli v29.6.2 · opts/env.go · ValidateEnv` — bare `-e NAME` resolves through the Docker CLI process environment.
- `moby/moby docker-v29.6.2 · api/types/container/config.go · Config.Env` — Engine container environment metadata.
- `moby/moby docker-v29.6.2 · daemon/commit.go · merge` — image `ENV` as defaults and runtime/user-key precedence.
- `moby/moby docker-v29.6.2 · daemon/container/env.go · ReplaceOrAppendEnvValues` — replace/append semantics and the distinction between an empty value and a bare unset key.
- `moby/moby docker-v29.6.2 · daemon/container/container.go · CreateDaemonEnvironment` — daemon defaults (`PATH`, `HOSTNAME`, conditional `TERM`) plus container configuration; same file also persists container configuration in `config.v2.json`.
- `moby/moby docker-v29.6.2 · daemon/oci_linux.go · withCommonOptions` — final assignment to OCI `s.Process.Env`.
- `opencontainers/runtime-spec v1.3.0 · config.md · process.env` — POSIX environment contract at the OCI boundary.
- `docker/compose v5.1.4 · cmd/compose/compose.go · toProjectOptions` — OS/project env-file/`.env` loading for the Compose project environment.
- `compose-spec/compose-go v2.11.0 · types/project.go · WithServicesEnvironmentResolved` — service `env_file` resolution and explicit `environment` override.
- `docker/compose v5.1.4 · pkg/compose/create.go` — resolved service environment to Moby `Config.Env`; local file-backed secret translated to a read-only bind mount at `/run/secrets/...`.
- `docker/compose v5.1.4 · pkg/compose/secrets.go` and `convergence.go` — environment-backed secret resolution and `CopyToContainer` injection before `ContainerStart`.
- `moby/moby docker-v29.6.2 · daemon/container_operations_unix.go` plus `daemon/container/container_unix.go` — Swarm worker secret tmpfs creation, secret-data write, UID/GID/mode application, read-only remount, and task secret mounts under `/run/secrets`.
- `docker-library/postgres commit 4f9ced0 · docker-entrypoint.sh · file_env` — `_FILE` as image/application convention; the same 2026 change unsets bootstrap `POSTGRES_*` credentials before final server exec to reduce process-environment exposure.
- `Linux man-pages 6.18 · proc_pid_environ(5)` — `/proc/<pid>/environ` semantics and ptrace-style access checks.

Source-over-folklore corrections recorded for this lesson:

1. Docker CLI `--env-file` is client-side input parsing, not a runtime secret-file or mount mechanism.
2. Compose `.env` / command-level project env-file input populates the Compose project/interpolation environment; service `env_file:` contributes to that service's runtime environment and ultimately becomes ordinary Moby `Config.Env`.
3. A local Compose `secrets: ... file:` source is a read-only bind mount, not a Swarm-style tmpfs secret. With a remote daemon, the bind source pathname is still interpreted on the daemon host, consistent with Lesson 32's daemon-host bind semantics.
4. A Compose environment-backed secret is injected as a file through `CopyToContainer` before start; this is distinct from both a file-backed bind secret and a Swarm secret.
5. A Swarm worker stages secret bytes in a private tmpfs, applies ownership/mode, remounts it read-only, then presents individual secret mounts to the task. Swarm manager/Raft/distribution internals remain deferred to Lesson 43.
6. `_FILE` has no generic Docker Engine meaning; support exists only when image/entrypoint/application code implements it.

### Continuation baseline issue — resolved 2026-08-08

The first continuation build of Lesson 35 used Moby 29.7.2 instead of this register's authoritative 29.6.2 family. After explicit learner authorization to redo Lessons 35 and 36, Lesson 35 received the required targeted audit and was rebuilt against Moby 29.6.2, containerd 2.2.6, runc 1.3.6, and OCI runtime-spec 1.3.0. The 29.7.2 draft is superseded.


## Lesson 35 compact source record — 2026-08-08

The compact Lesson 35 rebuild was rechecked against the pinned family before prose was shortened. Exact load-bearing anchors retained in the lesson:

- `containerd v2.2.6 · pkg/cio/io.go / io_unix.go` — `Config`, `NewCreator`, `NewFIFOSetInDir`, `openFifos`, and terminal-dependent stderr opening.
- `containerd v2.2.6 · core/runtime/v2/shim.go` — runtime-v2 uses task API v3 in this pinned release; `shimTask.Create` transports terminal/stdin/stdout/stderr endpoint information.
- `Moby docker-v29.6.2 · daemon/container/container.go` and `daemon/internal/stream/streams.go` — `InitializeStdio`, `startLogging`, `StreamConfig` broadcaster pipes, and `CopyToPipe`.
- `Moby docker-v29.6.2 · daemon/logger/copier.go` — per-source drain, newline parsing, ingestion timestamps, and partial-record behavior.
- `Moby docker-v29.6.2 · daemon/logs.go`, `daemon/attach.go`, `api/pkg/stdcopy/stdcopy.go`, and `daemon/logger/loggerutils/cache/local_cache.go` — stored log reading, live attach, non-TTY API framing, and local readable cache.
- `OCI runtime-spec v1.3.0 · process.terminal` plus `runc v1.3.6 · create.go --console-socket` — PTY topology.
- `Moby docker-v29.6.2 · daemon/logger/ring.go` — non-blocking queue behavior, including dropping the incoming message when the populated queue would exceed its byte limit.

The compact rewrite changes presentation density only; these mechanisms and corrections remain learner-facing.


## Lesson 37 source record — 2026-08-08

Lesson 37 was built against the pinned Engine/runtime/OCI/Linux line and these exact implementation points:

- `moby/moby docker-v29.6.2 · daemon/start.go::containerStart` — OCI spec creation, containerd container/task creation, task start, and health-monitor initialization.
- `moby/moby docker-v29.6.2 · daemon/health.go` — health probe exec construction, configured user, timing, bounded output/logging, failure streak, and health-state transitions.
- `moby/moby docker-v29.6.2 · daemon/monitor.go::handleContainerExit` plus `daemon/internal/restartmanager/restartmanager.go::ShouldRestart` — main-task exit handling, restart policy evaluation, exponential backoff, and the stable-run backoff reset threshold.
- `moby/moby docker-v29.6.2 · daemon/container/container.go::{ExitOnNext,ShouldRestart,RestartManager}` plus `daemon/kill.go::killWithSignal` — manual-stop suppression/cancellation path separate from the stable-run threshold.
- `moby/moby docker-v29.6.2 · daemon/daemon.go::restore` — daemon-start restoration and policy-driven autostart behavior.
- `moby/moby docker-v29.6.2 · daemon/oci_linux.go::{getUser,WithUser,WithResources,WithNamespaces,createSpec}` and `daemon/daemon_unix.go::{getMemoryResources,getCPUResources,getPidsLimit}` — Docker configuration to numeric OCI user/resources.
- `moby/moby docker-v29.6.2 · daemon/update.go::ContainerUpdate` — live resource-update path.
- `docker/cli v29.6.2 · cli/command/container/opts.go` — learner-facing health, restart, resource, and user flags.
- `containerd v2.2.6 · client/task.go`, `core/runtime/v2/shim.go`, and `cmd/containerd-shim-runc-v2/task/service.go` — task start/wait/exec/update transport through the runtime-v2 shim path.
- `opencontainers/runc v1.3.6 · libcontainer/specconv/spec_linux.go::CreateCgroupConfig` — OCI resource fields to runc cgroup resource configuration, including CPU-share conversion for cgroup v2.
- `opencontainers/runc v1.3.6 · libcontainer/init_linux.go::setupUser` — supplementary groups, `setgid`, and `setuid`.
- `opencontainers/runc v1.3.6 · go.mod` — pins `github.com/opencontainers/cgroups v0.0.4`; the lesson follows that dependency for current cgroup-v2 writers.
- `opencontainers/cgroups v0.0.4 · fs2/{memory,cpu,pids}.go` and `utils.go` — writes to `memory.max`, `memory.low`, `memory.swap.max`, `cpu.max`, `cpu.weight`, and `pids.max`, plus conversion helpers.
- `opencontainers/runtime-spec v1.3.0 · config.md::process.user` and `config-linux.md::linux.resources` — numeric process credentials and Linux resource contract.
- `opencontainers/image-spec v1.1.1 · config.md` — image `User` default and compatibility-reserved runtime fields such as `Healthcheck`, `Memory`, `MemorySwap`, and `CpuShares`; the image spec does not define Docker's health/restart state machines.
- `Linux v6.18 · Documentation/admin-guide/cgroup-v2.rst` — kernel semantics for `memory.low`, `memory.max`, `cpu.weight`, `cpu.max`, and `pids.max`.

The lesson records the following source-over-folklore corrections: health state does not itself trigger restart; the 10-second restart-manager threshold is a backoff-reset condition rather than an activation delay; `memory.low` is reclaim protection rather than a soft ceiling; CPU bandwidth quota and CPU weight are distinct mechanisms; and selecting a non-root UID/GID is distinct from creating a user namespace.


## Lesson 38 independent CRIU pin and source record — 2026-08-08

The global Engine/runtime/OCI baseline remains unchanged. CRIU is installed externally and is not pinned by the Engine 29.6.2 dependency family, so Lesson 38 independently pins **CRIU v4.2.1** (tagged 2026-07-21) for CRIU-internal explanations. This is a lesson-specific provenance pin, analogous to independently pinning Compose where the Engine baseline does not govern that component. runc 1.3.6 itself checks for CRIU 3.0.0+ on its base RPC path and applies higher feature-specific minimums where needed.

Exact load-bearing anchors used by Lesson 38:

- `docker/cli v29.6.2 · cli/command/checkpoint/create.go::{newCreateCommand,runCreate}` — checkpoint ID/directory, `--leave-running`, and `Exit: !leaveRunning`.
- `docker/cli v29.6.2 · cli/command/container/start.go` — learner-facing `--checkpoint` and `--checkpoint-dir` restore options.
- `moby/moby docker-v29.6.2 · daemon/checkpoint.go::{getCheckpointDir,CheckpointCreate}` — checkpoint directory creation and handoff to the running task.
- `moby/moby docker-v29.6.2 · daemon/start.go::{ContainerStart,containerStart}` — experimental restore gate, explicit rejection of custom restore checkpoint directories, ordinary start preparation, checkpoint lookup, and new-task/start flow.
- `containerd v2.2.6 · core/runtime/v2/shim.go` and `cmd/containerd-shim-runc-v2/task/service.go::Checkpoint` — runtime-v2 checkpoint RPC path.
- `containerd v2.2.6 · cmd/containerd-shim-runc-v2/process/init.go::{Create,createCheckpointedState,checkpoint}` — checkpoint option translation and creation of staged `runc.RestoreOpts` rather than normal `runc create` when restoring.
- `containerd v2.2.6 · cmd/containerd-shim-runc-v2/process/init_state.go::createdCheckpointState.Start` — runc restore happens on task Start; restored PID is read from the PID file afterward.
- `opencontainers/runc v1.3.6 · checkpoint.go` and `restore.go` — user-facing CRIU controls, leave-running behavior, rootless warnings, and non-leave-running post-checkpoint destroy behavior.
- `opencontainers/runc v1.3.6 · libcontainer/criu_linux.go::{Checkpoint,Restore,criuSwrk}` — CRIU version checks, DUMP/RESTORE RPC, rootfs preparation, freezer/ptrace choice, cgroup and external namespace handling.
- `checkpoint-restore/criu v4.2.1 · criu/cr-dump.c::{cr_dump_tasks,dump_one_task,dump_task_mm,collect_fds}` — task stabilization with `PTRACE_SEIZE`, process-tree/state collection, memory mappings/pages, FDs, signals/timers and dump ordering.
- `checkpoint-restore/criu v4.2.1 · criu/cr-restore.c::{fork_with_pid,restore_one_alive_task,sigreturn_restore}` — process-tree/PID recreation, resource restoration, and final execution-context restoration via sigreturn machinery.
- `checkpoint-restore/criu v4.2.1 · images/*.proto` — checkpoint image schemas for core/thread, memory, descriptors, credentials and related state.
- `opencontainers/runtime-spec v1.3.0 · runtime.md::Lifecycle` — standard OCI runtime lifecycle lacks checkpoint/restore operations; checkpoint/restore here is an implementation extension.

Source-over-folklore corrections recorded: checkpoint files are live runtime state rather than container-image/rootfs content; restore creates new kernel/runtime objects rather than reviving old kernel structs; Docker's create/start split remains visible in the restore path; and checkpoint portability is constrained by kernel/external-resource compatibility rather than guaranteed by OCI.


## Lesson 40 source record

Lesson 40 was built against the existing pinned distribution/image line and these exact implementation/specification points:

- `opencontainers/image-spec v1.1.1 · descriptor.md · Content Digests` — descriptor digests identify the referenced byte content and are the verification boundary for untrusted content.
- `opencontainers/distribution-spec v1.1.1 · Definitions` — `Tag` is a custom human-readable pointer to a manifest; one manifest digest may have zero, one, or many tags. Distribution terminology includes image manifests and image indexes under the manifests endpoint.
- `opencontainers/distribution-spec v1.1.1 · Pulling manifests / Pulling blobs / Checking if content exists` — digest-addressed GET/HEAD semantics and client verification requirements.
- `opencontainers/distribution-spec v1.1.1 · Mounting a blob from another repository` — `POST /v2/<name>/blobs/uploads/?mount=<digest>&from=<other_name>`, with `201 Created` for successful mount and `202 Accepted` as an upload-session fallback outcome.
- `containerd v2.2.6 · core/remotes/docker/resolver.go · dockerResolver.Resolve` — HEAD-first tag resolution, construction of `ocispec.Descriptor{Digest, MediaType, Size}` from response metadata, GET/hash fallback when digest/size metadata is missing, and direct digest-path handling for digest references.
- `containerd v2.2.6 · core/remotes/handlers.go · FetchHandler / Fetch` — `content.OpenWriter(...WithDescriptor(desc))` occurs before `fetcher.Fetch`, allowing the local content store to short-circuit remote body transfer for already-present content.
- `containerd v2.2.6 · plugins/content/local/store.go · Writer / writer / blobPath` — the expected digest is converted to `blobs/<algorithm>/<encoded>`; an existing path returns `ErrAlreadyExists`.
- `containerd v2.2.6 · plugins/content/local/writer.go · Write / Commit` — written bytes feed the digester; commit compares actual digest with expected, then targets the digest-derived blob path and renames ingest data into place.
- `containerd v2.2.6 · core/remotes/docker/pusher.go` — remote HEAD existence checks; blob cross-repository mount attempt using the descriptor digest plus a source repository candidate; ordinary upload fallback when needed.
- `containerd v2.2.6 · core/remotes/handlers.go · push / PushContent / annotateDistributionSourceHandler` — already-existing remote content returns before `provider.ReaderAt`; distribution-source labels are propagated onto children for cross-repository mount/fetch use.
- `moby/moby docker-v29.6.2 · daemon/containerd/image_pull.go` and `image_push.go` — Docker Engine ownership around the containerd distribution pipeline; on push, `findMissingMountable` reads distribution-source metadata and identifies potentially mountable missing descendants, `canBeMounted` excludes manifests/indexes and requires the same registry domain, and `appendDistributionSourceLabel` records the pushed target as a later distribution source.
- `docker/cli v29.6.2 · cli/command/image/pull.go` and `push.go` — learner-facing Docker CLI entry points into the Engine API.

The lesson records the source-over-folklore correction that “Docker deduplicates layers” is too vague. The actual transfer/store reuse decision shown here is per exact descriptor digest, and it applies to manifests/indexes/configs/layers. It also records that tag aliasing does not eliminate tag-resolution metadata traffic and that a new tag can still require a root manifest/index PUT even when all child blobs are already present.


## Lesson 40 second clarity rebuild note — 2026-08-09

The Lesson 40 source baseline and source-level conclusions are unchanged after reinspection of OCI image-spec v1.1.1 `descriptor.md`, OCI distribution-spec v1.1.1 `spec.md`, containerd v2.2.6 `core/remotes/docker/{resolver.go,pusher.go}`, `core/remotes/handlers.go`, `plugins/content/local/{store.go,writer.go}`, and Docker Engine `docker-v29.6.2` `daemon/containerd/image_push.go`. The rebuild changes teaching order only.

Canonical source-to-explanation order for Lesson 40 is now:

1. `dockerResolver.Resolve` — a tag goes through the manifests path and normally HEAD; registry metadata is assembled into the root descriptor, with GET/hash fallback when needed.
2. `remotes.Fetch` + local `store.writer` — the expected descriptor reaches the local store before `fetcher.Fetch`; an existing digest-derived path short-circuits the body fetch.
3. local `writer.Write` / `Commit` — incoming bytes feed the digester; commit compares calculated vs expected digest before final digest-addressed placement.
4. child descriptors repeat the same loop; image indexes add one descriptor hop rather than a new mechanism.
5. pusher remote HEAD + `remotes.push` — existing remote content returns before `provider.ReaderAt` opens payload bytes.
6. Engine `findMissingMountable` / `canBeMounted` plus containerd pusher mount branch — cross-repository reuse is an exact-digest, explicit-source request, not registry-wide semantic searching.


## Lesson 41 independent signing pin and source record — 2026-08-09

The global Docker/BuildKit/containerd/runc/OCI baseline remains unchanged. Docker CLI v29 removed its old built-in Docker Content Trust workflow, so Lesson 41 independently pins **sigstore/cosign v3.0.6** as the concrete external signing/verifying client. This is a lesson-local implementation pin, analogous to independently pinning CRIU or Compose where the Engine dependency graph does not govern the external component.

Exact load-bearing anchors used by Lesson 41:

- Docker Engine v29 release notes — records removal of Docker Content Trust from Docker CLI in v29; old `docker trust` signing is therefore not presented as the pinned current Docker CLI implementation.
- `moby/buildkit v0.31.1 · solver/llbsolver/provenance.go::{captureProvenance,ProvenanceCreator}` — provenance is captured from solved source/execution operations; secret/SSH mount records carry identifiers/options rather than secret payload values.
- `moby/buildkit v0.31.1 · exporter/containerimage/writer.go` — per-platform `defaultSubjects` use the just-created platform manifest `desc.Digest`; in-toto statements are created from those subjects.
- `moby/buildkit v0.31.1 · exporter/containerimage/writer.go::commitAttestationsManifest` — statement JSON is serialized, digested, written as content, referenced from an attestation manifest, and attestation-manifest descriptors are appended to the root image index beside platform manifests.
- `opencontainers/image-spec v1.1.1 · manifest.md::subject` — optional subject descriptor is a weak association to another manifest; attachment alone is not a trust proof.
- `opencontainers/distribution-spec v1.1.1 · Referrers API` — `GET /v2/<name>/referrers/<digest>` returns an OCI image index of referring manifest descriptors and is a discovery mechanism, not cryptographic verification.
- `sigstore/cosign v3.0.6 · cmd/cosign/cli/sign/sign.go::signDigestBundle` — digest reference is decomposed into the in-toto resource descriptor/statement subject before the payload is passed to signing/bundle logic.
- `sigstore/cosign v3.0.6 · cmd/cosign/cli/verify/verify.go::VerifyCommand.Exec` — trust/verifier material is loaded; new bundle verification installs `IntotoSubjectClaimVerifier` and invokes image-attestation verification, keeping cryptographic verification and claim-target verification together in the verifier path.

Lesson 41 records these source-over-folklore corrections: provenance generation is not a cryptographic signature; signatures should be understood as digest-bound rather than tag-bound; an OCI outer `subject`/referrers relationship is only discovery/association; moving a tag does not transfer an old signature to the new digest; and a signature over the final root digest transitively fixes the exact descriptor graph but does not independently prove the truth of the provenance predicate.


## Lesson 42 Compose source record — 2026-08-09

Lesson 42 was built from the pinned parent Docker CLI/Engine 29.6.2 and independently pinned Docker Compose v5.1.4 / compose-go v2.11.0 line. Exact load-bearing implementation points:

- `docker/cli v29.6.2 · cli-plugins/manager/manager.go::PluginRunCommand` — the parent Docker CLI resolves the Compose CLI plugin executable, starts it as a separate process, and forwards stdio/environment.
- `docker/compose v5.1.4 · cmd/main.go::pluginMain` — Compose's plugin-process entry point.
- `docker/compose v5.1.4 · go.mod` — exact dependency pin to `github.com/compose-spec/compose-go/v2 v2.11.0` and embedded Docker CLI library v29.5.1; this does not replace the course's parent CLI/Engine 29.6.2 baseline.
- `compose-spec/compose-go v2.11.0 · cli/options.go::{ProjectOptions.LoadProject,prepare,withNamePrecedenceLoad}` — turns one or more Compose config inputs into the resolved project model and implements project-name precedence.
- `compose-spec/compose-go v2.11.0 · types/project.go::Project` — the in-memory application model containing project name, services, networks, volumes, and related resolved configuration.
- `compose-spec/compose-go v2.11.0 · loader/normalize.go::{normalizeNetworks,setNameFromKey}` — inserts the logical `default` network when a service needs it and no explicit network is attached, and derives Engine-facing network/volume names such as `<project>_<key>` for unnamed non-external resources.
- `compose-spec/compose-go v2.11.0 · transform/dependson.go::transformDependsOn` — short `depends_on` entries normalize to the `service_started` condition with `required: true`.
- `docker/compose v5.1.4 · pkg/api/labels.go` — exact `com.docker.compose.*` labels for project, service, config hash, container number, volume/network identity, project files/working directory, and related metadata.
- `docker/compose v5.1.4 · pkg/compose/containers.go::{getContainers,getDefaultFilters}` and `filters.go::projectFilter` — rediscovery of existing Engine containers through label-filtered `ContainerList` requests rather than through a separate Compose runtime database.
- `docker/compose v5.1.4 · pkg/compose/up.go::Up` and `create.go::create` — `up` performs create/reconcile before start; create prepares/ensures networks and declared volumes, discovers existing project containers, then invokes convergence.
- `docker/compose v5.1.4 · pkg/compose/convergence.go::{ensureService,getScale,mustRecreate,getDefaultContainerName,createMobyContainer,startService,waitDependencies,shouldWaitForDependency}` — target replica calculation, reuse/recreate/scale decisions, default `<project>-<service>-<number>` container naming, Engine `ContainerCreate`/`ContainerStart`, and readiness-condition waiting. A custom `container_name` cannot be combined with scale greater than one.
- `docker/compose v5.1.4 · pkg/compose/dependencies.go::{InDependencyOrder,InReverseDependencyOrder}` — dependency graph traversal used for start and removal ordering.
- `docker/compose v5.1.4 · pkg/compose/down.go` — project-container discovery, reverse dependency removal, owned-network cleanup, optional named-volume cleanup, and skipping external networks/volumes.
- `moby/moby docker-v29.6.2 · daemon/server/router/container/container_routes.go::{postContainersCreate,postContainersStart}`, `daemon/server/router/network/network_routes.go::postNetworkCreate`, and `daemon/server/router/volume/volume_routes.go::postVolumesCreate` — server-side Engine API endpoints where ordinary Docker containers, networks, and volumes become dockerd-owned resources.

Source-over-folklore corrections recorded by Lesson 42:

1. Compose is not a second runtime or daemon. The plugin resolves an application model and reconciles ordinary Engine resources; after Engine container start, the already-taught dockerd → containerd → shim → runc → kernel chain owns runtime execution.
2. A Compose service is desired configuration plus a target scale, not a container identity. One service can converge to multiple ordinary Engine containers.
3. Compose resource continuity is label-driven and name-driven. Later `up`/`down` operations rediscover Engine objects with `com.docker.compose.*` metadata rather than consulting a hidden persistent Compose runtime database.
4. Short `depends_on` means dependency/start ordering (`service_started`), not readiness. `service_healthy` is the explicit condition that waits on Engine-reported health.
5. `docker compose down` does not mean “delete everything.” External resources are skipped, and declared named volumes are retained unless volume removal is explicitly requested.
6. The implicit `default` network is a resolved logical network only when services need it; it is not proof that every Compose file always materializes a new default Engine network regardless of usage.


## Lesson 43 Swarm source record — 2026-08-09

The global Docker/OCI/runtime baseline remains unchanged. Docker Engine **29.6.2** directly pins the Swarm control-plane implementation in its `go.mod` as `github.com/moby/swarmkit/v2 v2.1.3-0.20260609123145-f80b112cff7d`, resolved to full commit **f80b112cff7d2fa4b67eff36f0bdd2cbd05be0d8**. Lesson 43 uses that exact commit for SwarmKit implementation facts.

Exact load-bearing anchors used by Lesson 43:

- `docker/cli v29.6.2 · cli/command/swarm/init.go::runInit` — learner command → Engine Swarm-init API.
- `moby/moby docker-v29.6.2 · daemon/cluster/swarm.go::Cluster.Init` and `daemon/cluster/cluster.go` — dockerd starts/owns the embedded Swarm node.
- `moby/swarmkit f80b112... · node/node.go::{Node,run}` — every node runs an agent; a manager node also runs the manager component; managers may still handle workloads.
- `docker/cli v29.6.2 · cli/command/service/create.go` + `moby/moby docker-v29.6.2 · daemon/cluster/services.go::CreateService` — ServiceSpec enters the Engine API and is forwarded to the embedded Swarm control API; the Engine path can digest-pin the image reference.
- `moby/swarmkit f80b112... · manager/controlapi/service.go::Server.CreateService` — validates and stores a Service desired-state object; it does not create containers directly.
- `manager/state/store/memory.go::{MemoryStore.Update,update}` + `manager/state/raft/raft.go::{MemoryStore,Run,ProposeValue}` — store mutations become StoreActions proposed through Raft and applied after commit; the in-memory store is kept in sync with the Raft log.
- `manager/manager.go::becomeLeader` — leader-only replicated orchestrator and scheduler startup; fresh-cluster default ingress-network creation.
- `manager/orchestrator/replicated/services.go::{reconcile,addTasks}` — desired replica slots → Task object creation/removal decisions.
- `manager/scheduler/scheduler.go` — chooses an eligible node and writes `Task.NodeID` / ASSIGNED state; it does not execute the task.
- `manager/dispatcher/dispatcher.go::Assignments` — authenticated per-node stream of full/incremental assignments.
- `agent/worker.go::Worker.Assign/newTaskManager` + `agent/exec/controller.go::Do` — worker reconciles dependencies, resolves the task controller, and advances task execution states.
- `moby/moby docker-v29.6.2 · daemon/cluster/executor/container/{controller.go,adapter.go}` — worker-side Swarm executor uses `CreateManagedContainer` and `ContainerStart`, which is the handoff into the ordinary Docker runtime path taught in Lesson 23.
- `manager/orchestrator/restart/restart.go::Supervisor.Restart` — old task is driven toward shutdown and a new Task is created under restart policy.
- `manager/orchestrator/update/updater.go::{Updater.worker,updateTask}` — changed service specs produce replacement tasks, with start-first/stop-first ordering handled around task replacement.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/drivers/overlay/ov_network.go::setupSubnetSandbox` — Linux overlay realization creates bridge + VXLAN devices.
- `moby/moby docker-v29.6.2 · daemon/libnetwork/service_linux.go::addLBBackend` — Linux service VIP load balancing programs IPVS service/destination state.

Source-over-folklore corrections recorded by Lesson 43:

1. Swarm is not another container runtime. It is a cluster control plane embedded in dockerd; worker execution eventually returns to the ordinary dockerd → containerd → shim → runc → kernel path.
2. A Swarm service is not a container. `Service → Task → container` are distinct stages/objects.
3. Raft replicates desired/control-plane state among managers; it does not replicate live containers or perform scheduling/execution.
4. The scheduler records a node assignment on a Task; the worker executor creates the actual local container later.
5. Restart/failover does not migrate a live container. Swarm creates a replacement Task, schedules it, and realizes a new local container.
6. Orchestration placement and packet transport are separate pipelines. VXLAN/IPVS are Linux networking realization below the manager scheduling decisions.


## Lesson 44 final security source record — 2026-08-09

The global baseline remains Docker Engine / Docker CLI **29.6.2**. No newer Engine, CLI, OCI, containerd, or runc revision was introduced. No independent RootlessKit revision is promoted to a new course-wide pin: Lesson 44 uses the exact RootlessKit integration behavior visible in the pinned Engine 29.6.2 rootless launcher and setup scripts.

Exact load-bearing anchors used by Lesson 44:

- `moby/moby docker-v29.6.2 · contrib/dockerd-rootless.sh` — refuses UID 0; explicitly re-execs through RootlessKit to create unprivileged user/mount/network namespaces; then executes `dockerd` in the child environment. The script's networking helper selection is implementation-dependent (`slirp4netns`, then `pasta`, then `vpnkit`, then `gvisor-tap-vsock` fallback when not explicitly configured), so the lesson does not teach one helper as universal.
- `moby/moby docker-v29.6.2 · contrib/dockerd-rootless-setuptool.sh` — checks `newuidmap`/`newgidmap`, `/etc/subuid` and `/etc/subgid`; creates a per-user systemd unit executing `dockerd-rootless.sh`; creates the CLI context at `unix://$XDG_RUNTIME_DIR/docker.sock`.
- `moby/moby docker-v29.6.2 · daemon/listeners/listeners_linux.go::Init` — a Unix Engine listener resolves the socket group and creates the Unix socket, establishing the local transport-permission boundary.
- `moby/moby docker-v29.6.2 · daemon/server/router/container/container_routes.go::postContainersCreate` — decodes an Engine create request into `Config`, `HostConfig`, and networking configuration.
- `moby/moby docker-v29.6.2 · api/types/container/hostconfig.go::HostConfig` — exposes host-sensitive controls including `Binds`, `Privileged`, `CapAdd`, namespace modes, `SecurityOpt`, and `Mounts`. This is the source-level basis for treating unrestricted access to a rootful daemon's API as root-level Docker authority.
- `moby/moby docker-v29.6.2 · pkg/authorization/middleware.go::Middleware.WrapHandler` — if no authz plugins exist, invokes the Engine handler directly; otherwise calls request authorization before the handler and response authorization afterward. TLS peer certificate Common Name is used as the middleware user identity when present.
- `moby/moby docker-v29.6.2 · pkg/authorization/authz.go::Ctx.AuthZRequest / AuthZResponse` — constructs the authorization request context, walks the plugin chain, fails on plugin error or `Allow=false`, and applies the documented AND semantics across multiple plugins.
- `moby/moby docker-v29.6.2 · pkg/authorization/plugin.go::Plugin / authorizationPlugin` — defines the request/response policy interface, lazily resolves the configured plugin through the Docker plugin subsystem, and calls the authorization plugin endpoints.

Source-over-folklore corrections recorded by Lesson 44:

1. Rootless Docker is not merely `USER 1000` in a container. It changes the authority of the daemon itself by starting dockerd inside an unprivileged namespace environment.
2. Rootless Docker is not the same as rootful `userns-remap`; the latter remaps container users while dockerd remains host-root.
3. `docker.sock = root` is shorthand that needs a condition: unrestricted access to the **rootful** Engine API is effectively root-level Docker authority. A rootless daemon socket is still a powerful authority endpoint, but the daemon's outer host privilege is different.
4. Authorization plugins do not sandbox containers and do not de-privilege dockerd. They are request/response policy middleware in the Engine API path.
5. Multiple authorization plugins are not alternatives: the allow decision is the AND of all configured plugin results.
