# Docker course transfer bundle

This bundle is the approved continuity package, updated on **2026-08-07** through **Lesson 34**.

## Contents

- `lessons/` — Lessons 1–34 plus the approved ChainID supplement. Lessons 1–28 retain the targeted source-supported corrections; Lessons 29 and 31 are learner-approved clarity rebuilds; Lesson 30 covers `ARG`, `ENV`, history, provenance, and secret mounts; Lesson 32 covers runtime storage mounts; Lesson 33 covers network namespaces, veth, bridge/host/none, forwarding/NAT, and published-port DNAT using a foundation-first “who configures / who executes / what changes” packet model; Lesson 34 covers user-defined bridges, embedded DNS, macvlan, and ipvlan.
- `reference/course-map.md` — authoritative 46-lesson order and status.
- `reference/lesson-method.md` — source-research and teaching workflow.
- `reference/html-style-guide.md` — visual system and reusable components.
- `reference/progress-and-decisions.md` — progress and approved learner decisions.
- `reference/source-baseline-and-corrections.md` — pinned release family, source records, and correction register.
- `reference/correction-log.md` — targeted transfer corrections and lesson-creation records.
- `validation-report.json` — integrity and validation results.

Lessons 1–31 are recorded as studied. Lessons 32, 33, and 34 are created and awaiting study. Lesson 34 was explicitly requested despite the unresolved study status of Lessons 32 and 33; that creation exception is recorded rather than silently marking either earlier lesson studied.

### 2026-08-07 Lesson 33 visual-mechanism rebuild

Lesson 33 was rebuilt again at learner request because IP forwarding, SNAT/MASQUERADE, and DNAT still appeared as terminology before their packet-level problems were fully visible. The canonical Lesson 33 file now explains each mechanism as a packet problem first, then names it, and uses small focused CSS-animated diagrams for forwarding, source NAT, and destination NAT. Source-level depth is preserved in the second-read implementation sections. Study statuses are unchanged.



## Lesson 33 foundation-first rebuild

The canonical Lesson 33 in this bundle was rebuilt on 2026-08-07 after the learner reported that the prior revision still assumed too much networking vocabulary. The revision defines each packet-path actor before using shorthand terms and makes the dockerd/libnetwork configuration role distinct from the Linux kernel execution role. The technical baseline and study status are unchanged.


Current Lesson 33 revision: depth-plus-diagrams rebuild — foundation-first explanatory depth restored, 13 standalone inline-SVG mechanism diagrams retained, and first-use networking terms defined before reuse; study status unchanged.


## Lesson 33 depth-plus-diagrams rebuild

The canonical Lesson 33 was rebuilt again on 2026-08-07 to combine the original foundation-first depth with standalone drawn diagrams. The lesson now enforces a first-use definition rule for networking terminology and names configuration-time versus packet-time actors for each mechanism. Technical baseline and study status are unchanged.
