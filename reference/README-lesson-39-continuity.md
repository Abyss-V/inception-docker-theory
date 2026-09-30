# Lesson 39 continuity note

Status date: **2026-08-09**

- Lesson 39: **Registries & the OCI distribution-spec HTTP API** — created; awaiting study; learner-requested clarity rebuild completed.
- Baseline unchanged: Docker Engine/Docker CLI 29.6.2; containerd 2.2.6; OCI distribution-spec 1.1.1; OCI image-spec 1.1.1.
- Prerequisite context reused: Lessons 18, 19, 20, 22, and the image-pull stage of Lesson 23.
- Governing learner model: track the exact moving object at every hop. Pull = reference/control request → root descriptor → manifest/index JSON → child descriptors → config/layer bytes → containerd content store → unpack. Push = local child blobs → registry upload session/commit → manifests → parent indexes last.
- Preserve these source-backed mechanisms: containerd 2.2.6 resolves tagged manifests HEAD-first with GET fallback when required metadata is missing; manifest/index media types use the manifest endpoint while config/layer blobs use the blob endpoint; Engine 29.6.2 requests pull unpack; push parents are committed after children; registry authentication is separate from the OCI Distribution content protocol.
- OCI distribution-spec 1.1.1 also defines chunked upload. The learner-facing lesson contains this only as a self-contained optional branch because pinned containerd 2.2.6 uses the whole-body monolithic POST→PUT path and records chunked upload as TODO.
- Scope boundary strengthened by learner request: Lesson 39 must not assume knowledge of cross-repository mount/dedup (Lesson 40) or referrers/signing/provenance (Lesson 41). Discovery/deletion/conformance catalogs are not part of the learner-facing Lesson 39 core.
- Lessons 32–38 remain awaiting study.
- Next course slot: **Lesson 40 — Tags vs digests, content-addressed transfer & dedup**.
