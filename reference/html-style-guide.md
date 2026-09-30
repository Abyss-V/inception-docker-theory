# HTML and visual style guide

## Delivery format

- One standalone HTML file per lesson.
- Inline CSS only; no required external stylesheet, JavaScript bundle, font file, or image asset.
- Inline SVG is permitted for a diagram that materially improves understanding.
- Responsive layout and readable horizontal scrolling for terminal/source snippets.

## Canonical visual tokens

```css
:root {
  --ink: #0e1116;
  --panel: #161b22;
  --well: #0a0d12;
  --bone: #e9e4d7;
  --dim: #9aa4b2;
  --faint: #6b7482;
  --rule: #262d38;
  --gold: #e0b155;
  --gold-dim: #7a6636;
  --teal: #5ac4b4;
  --teal-dim: #2f5f59;
  --rose: #d76d7f;
  --rose-dim: #6e3540;
  --mono: ui-monospace, "SF Mono", "JetBrains Mono", Menlo, Consolas, monospace;
  --serif: "Iowan Old Style", Charter, Georgia, Cambria, serif;
}
```

Default body: `18px`, approximately `1.7` line height, warm serif prose on the ink background. Main reading column: approximately `760px`, centered, with 24px side padding.

## Semantic color roles

- **Gold:** exact primary-source anchors, implementation identifiers, provenance.
- **Teal:** hands-on inspection, governing ideas, navigation, successful path.
- **Rose:** corrections, unsafe assumptions, folklore contradicted by source.
- **Dim/faint:** supporting explanation and annotations.

Do not use the accents decoratively; each has a fixed semantic job.

## Reusable components

1. Header: course part, oversized lesson number, `CORE` or `DEEP-CUT` pill, title, short deck.
2. Governing-idea panel (`oneline`).
3. Numbered concept marker and monospace section heading.
4. Plain-language preface for a difficult mechanism.
5. Inline source-reference chip naming exact path/function/field.
6. Optional diagram (`figure` + inline SVG), only when spatial/flow/state structure warrants it.
7. Terminal inspection panel with a labeled tab.
8. Teal note box for operational nuance.
9. Rose correction box for source-over-folklore corrections.
10. Check-yourself recap.
11. Back/forward cross-reference chips and previous/next navigation.

## Source presentation decision

The early lessons visibly include large source-code panels. The approved learner-facing pattern for new lessons removes large raw Go/C blocks from the main explanation because they obstructed comprehension. Preserve exact source provenance in prose and, when useful, put the minimum excerpt in a collapsed appendix. Do not retrofit every completed lesson solely for visual uniformity.

## Diagram rule

A diagram must carry information that prose would force the learner to reconstruct mentally: nested sets, a namespace mapping, an OverlayFS stack, a state machine, or a multi-stage pipeline. A list, simple contrast, or short sequence should remain prose or a compact table. Default to zero diagrams; normally use at most one.
