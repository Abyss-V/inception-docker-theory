# Lesson research and writing method

## Authority and conflict order

1. The approved course map, progress record, decisions, and correction register govern structure and continuity.
2. Current pinned primary sources govern technical facts.
3. Existing lessons are prerequisite context, but a verified primary-source correction wins and must be recorded explicitly.
4. Blogs, generic summaries, and memory are not foundations for an explanation.

When files disagree, report the conflict. Do not silently choose or rewrite completed work.

## Before writing a lesson

1. Read `course-map.md`, `progress-and-decisions.md`, and `source-baseline-and-corrections.md`.
2. Review the lessons on which the new lesson depends.
3. Start from the pinned Docker Engine release, then use its compatible/bundled containerd, runc, BuildKit, and OCI specifications. Record exact tags or commits.
4. Inspect the actual specification sections and implementation files before drafting.
5. Report the **3–5 most important findings** in plain language, especially facts that correct common explanations.
6. Wait for direction when the workflow requires approval. Work on one lesson only.

## Learner-facing explanation pattern

1. **State the governing idea in one sentence.**
2. **Make the need intuitive before naming the parts.** Explain the problem that forces the mechanism to exist.
3. **Follow real execution order.** Name the responsible component at each step; avoid vague “Docker does this” wording.
   - For a multi-component mechanism, begin with the whole movement pipeline: show what object/value/bytes are moving, which component receives them at each hop, where they live at that moment, and what changes before the next hop. Then zoom into the hops in order.
4. **Explain one load-bearing relationship until it clicks.** Do not list unexplained terms to sound complete.
5. **Name primary-source anchors in prose.** Give repository/tag, path, function or structure, field, flag, constant, or syscall.
6. **Keep large raw Go/C excerpts out of the main narrative.** A compact, collapsed primary-source appendix may include the minimum excerpt needed for auditability.
7. **Use a diagram only when the structure is genuinely difficult to hold in prose**—for example, a state machine, layered filesystem, namespace mapping, or multi-hop pipeline. Most lessons should have zero or one diagram.
8. **Provide an inspect-it-yourself command or experiment.** It must observe the mechanism on a real Linux/Docker system, not merely repeat the documentation.
9. **State source-over-folklore corrections explicitly.** Do not silently round to a familiar but incomplete count.
10. End with a compact recap and a short transition to the approved next lesson.

## Depth and scope

- Explain **how**, not only what: execution order, functions, fields, file paths, syscalls, flags, ordering constraints, edge cases, and relevant maintainer comments.
- Do not invent source-level depth for a feature that is primarily configuration or UX.
- `CORE` and `DEEP-CUT` are study-priority labels. They do **not** reduce accuracy or omit mechanisms.
- Stay inside the current lesson. Cross-reference prior material instead of re-teaching it, and defer later mechanisms to their numbered lesson.

## Questions during study

For precise questions about Docker behavior, inspect the relevant pinned source before answering. Distinguish:

- Docker CLI command behavior
- Docker Engine API behavior
- containerd task/runtime-v2 behavior
- OCI operation semantics
- live Linux kernel objects versus their on-disk configuration

If the source does not support a claim, say so rather than filling the gap from memory.
