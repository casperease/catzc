# Thesis explanations

```text
What cats is for, as a deck.

Product thesis   one source of truth, six principles, twelve domains, in 21 slides
Eac normal form  a file leaves the unordered track only in the normal form
```

These pages explain the [thesis decision-record domain](../../drs/index.md#thesis). The product thesis is a deck kept as slide files under
[product-thesis](product-thesis/deck.md), rendered through the slides kit ([ADR-REPO-SLIDES](../../drs/repository/slides-as-markdown.md));
the [explanation index](../index.md) says how to read the explanations.

- [A file leaves the unordered track only in the normal form](eac-normal-form.md) — the eac normal form and fragment migration
  ([TDR-NORMALFORM](../../drs/thesis/eac-normal-form.md)).

```yml drawio
description:
  "Where truth comes from: in every mode the repository at one commit decides; in the listen mode the editor's edit is fact, and the plans
  it starts flow from the rule to the docs to the code."
about:
  adrs: [TDR-ONETRUTH, ADR-REPO-AI-EDITORISFACT, ADR-REPO-PLANS-DECISIONSBECOMERULES]
  lens: meta
content:
  title: Truth is one commit; in the listen mode the editor's edit is fact, and its plans run rule, docs, code
  kind: explanation
  flow: left-to-right
  relation: what decides
  theme: dark
  bands:
    - { id: band-default, label: EVERY MODE }
    - { id: band-listen, label: LISTEN MODE }
    - { id: band-plan, label: PLAN ORDER }
  glyphs:
    - { id: s-repo, kind: store, label: "the repository at one commit, committed files only", in: band-default }
    - { id: a-editor, kind: actor, label: the editor, in: band-listen }
    - { id: r-fact, kind: result, label: the edit is fact, in: band-listen }
    - { id: f-note, kind: file, label: a note, in: band-listen }
    - { id: s-rule, kind: drsonly, label: rule (DRS), in: band-plan }
    - { id: f-docs, kind: file, label: docs, in: band-plan }
    - { id: k-code, kind: code, label: code and configs, in: band-plan }
  edges:
    - { from: a-editor, to: r-fact, kind: flow, label: corrects }
    - { from: r-fact, to: f-note, kind: flow, label: "" }
    - { from: f-note, to: s-rule, kind: thick, label: plans }
    - { from: s-rule, to: f-docs, kind: flow, label: "" }
    - { from: f-docs, to: k-code, kind: flow, label: "" }
  legend: auto
  minimaps: [axis, lifecycle-position, layer-stack]
layout:
  s-repo: { x: 60, y: 150, w: 320, h: 90 }
  s-rule: { x: 895, y: 266, w: 130, h: 44 }
  f-docs: { x: 1062, y: 266, w: 110, h: 50 }
  k-code: { x: 1040, y: 150, w: 150, h: 44 }
```

![Truth is one commit; in the listen mode the editor's edit is fact, and its plans run rule, docs, code][diagram]

[diagram]: .assets/where-truth-comes-from.drawio.png
