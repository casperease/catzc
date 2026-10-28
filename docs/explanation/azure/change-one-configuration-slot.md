# Changing one configuration slot runs only its owner's pipeline and reaches only its resource group

```text
Changing one configuration slot runs only its owner's pipeline and reaches only its resource group.

1  one slot file             the edit: one <env>[-<slot>].yml in the configs place of the infrastructure track
2  the owner's CD pipeline   the one pipeline whose path filter holds the slot: the shared one or the customer's
3  every other CD pipeline   stays still, because its filter excludes the slot's folder
4  the slot's resource group the one resource group the slot deploys, and the only one the change reaches

Supports ADR-AZ-IACKIND-THREEIACKINDS and ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION (operations lens).
```

The smallest infrastructure change is an edit to one configuration slot: a setting of one deployment, in one file. Because a slot is one
resource group and its folder says whose deployment it is, the change has a known, narrow reach before it is merged: one pipeline runs, and
one resource group changes.

```yml drawio
description:
  Changing one configuration slot edits one file in the configs place of the infrastructure track; only the CD pipeline of the slot's owner
  runs, and the change reaches the one resource group the slot deploys.
about:
  rules: [ADR-AZ-IACKIND-THREEIACKINDS, ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION]
  lens: operations
content:
  title: Changing one configuration slot runs only its owner's pipeline and reaches only its resource group
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-edit, label: THE EDIT }
    - { id: band-pipeline, label: PIPELINE }
    - { id: band-deployed, label: DEPLOYED }
  spans:
    - id: span-configs
      label: configs
      over: [band-edit]
  glyphs:
    - { id: g-slot, kind: file, label: one slot file, in: band-edit }
    - { id: r-owner, kind: runner, label: the owner's CD pipeline, in: band-pipeline }
    - { id: r-others, kind: runner, label: every other CD pipeline, in: band-pipeline }
    - { id: e-group, kind: env, label: the slot's resource group, in: band-deployed }
  edges:
    - { from: g-slot, to: r-owner, kind: flow, label: feeds }
    - { from: r-owner, to: e-group, kind: flow, label: "" }
  markers:
    - { at: g-slot, number: 1 }
    - { at: r-owner, number: 2 }
    - { at: r-others, number: 3 }
    - { at: e-group, number: 4 }
  legend: auto
  minimaps: [code-locations, axis, lifecycle-position]
layout:
  r-owner: { x: 540, y: 140, w: 220, h: 44 }
  r-others: { x: 540, y: 196, w: 220, h: 40 }
  e-group: { x: 960, y: 132, w: 220, h: 60 }
```

![Changing one configuration slot runs only its owner's pipeline and reaches only its resource group][diagram]

[diagram]: .assets/change-one-configuration-slot.drawio.png

## Walkthrough

1. **One slot file.** The operator edits `configuration/[<customer>/]<env>[-<slot>].yml` under one template. The file sits in the track's
   `configs` place, so nothing else is touched: no template, no module, no pipeline.
2. **The owner's CD pipeline.** A slot at the configuration root belongs to the shared platform and one under a customer subfolder belongs
   to that customer. Each CD pipeline's path filter includes its owner's slots, so the merge triggers exactly that pipeline.
3. **Every other CD pipeline.** The other pipelines exclude the slot's folder in their filters, so they do not run for this change.
4. **The slot's resource group.** One slot is one subscription and one resource group, so the deployment that follows changes that group and
   no other.

## Why it holds

- A configuration slot is one of the three kinds of infrastructure code, and every infrastructure file is of one kind
  (ADR-AZ-IACKIND-THREEIACKINDS).
- One config file is one (customer?, env, slot), one subscription and one Azure resource group, so a change to one file reaches one group
  (ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION).

## See also

- [Infrastructure code is of three kinds](three-kinds-of-infrastructure-code.md) — the three kinds and their places.
- [A config file's path is a coordinate](config-path-is-a-coordinate.md) — how the slot's path resolves to its subscription.
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
