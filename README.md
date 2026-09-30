# Docker internals course handoff

Start with **`README-NEXT-CHAT.md`**. It records the current state through the final numbered Lesson 44 and the learner-approved merge of the final security material.

## Current state

- Lessons 1–31 are recorded as studied.
- Lessons 32–44 exist and remain awaiting study unless the learner explicitly says otherwise.
- Lesson 44 is the final numbered lesson and merges the former planned Rootless Docker, Plugins & authz, and `docker.sock = root` security-capstone lessons.
- Current approved course size: **44 numbered lessons**.
- Former lesson numbers 45 and 46 are retired/absorbed, not missing.

## Final lesson source identity

Lesson 44 keeps Docker Engine / Docker CLI **29.6.2**. Its implementation anchors are the pinned Engine rootless launcher/setup scripts, Unix listener, container-create `HostConfig`, and Engine authorization middleware/plugin code. No newer Docker baseline was introduced.

Its canonical security model is: **workload sandbox ≠ API authorization ≠ daemon privilege boundary**.
