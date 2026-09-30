# Lesson 38 continuity note

Status date: **2026-08-08**

- Lesson 38 — **Checkpoint/restore (CRIU)** — has been created as a standalone pipeline-first dark-theme HTML lesson and is **awaiting study**.
- Lessons 32–37 retain their prior awaiting-study status. No study completion is inferred from the learner explicitly requesting creation of Lesson 38.
- Global source baseline remains Docker Engine/Docker CLI 29.6.2, containerd 2.2.6, runc 1.3.6, OCI runtime-spec 1.3.0, OCI image-spec 1.1.1, OCI distribution-spec 1.1.1, with Linux 6.18/man-pages 6.18 at the kernel boundary.
- CRIU is external to that dependency family; Lesson 38 independently pins CRIU **v4.2.1** for its CRIU-internal source explanations.
- Core corrections: checkpoint files are runtime state rather than a Docker image/rootfs snapshot; restore reconstructs new live kernel/runtime objects; OCI does not standardize checkpoint/restore; Engine 29.6.2 restore is experimental and rejects a custom restore checkpoint directory.
- Next approved course slot is Lesson 39 — **Registries & the OCI distribution-spec HTTP API**. Do not create it until the learner asks to continue.


## 2026-08-09 clarity rebuild

Lesson 38 has been rebuilt a second time after learner feedback that the shortened version was still not explained well. The authoritative technical claims and pins did not change. The current lesson must be treated as the canonical Lesson 38 version. Its teaching spine is: concrete process state → why rootfs is insufficient → checkpoint movement → CRIU dump mechanics → two-input restore → `rt_sigreturn` continuation. Do not restore the older abstract/repetitive structure.
