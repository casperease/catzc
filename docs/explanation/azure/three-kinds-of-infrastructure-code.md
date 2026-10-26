# Infrastructure code is of three kinds, and a template pulls its modules and its configuration slots together

```text
Infrastructure code is of three kinds, and a template pulls its modules and its configuration slots together.

1  reusable module      one .bicep file a template references, never deployed alone
2  main.bicep           the template's deployable entry, which pulls in the modules it references
3  options.yml          the template's own settings, beside its main.bicep
4  configuration slot   one <env>[-<slot>].yml under the template's configuration folder, one per resource group
5  resource group       what one slot deploys the template into

Supports ADR-AZ-IACKIND-THREEKINDS and ADR-AZ-IACKIND-TRACKPLACESKINDS (meta lens).
```

Every infrastructure file in cats is one of three kinds: a reusable module, a template, or a configuration slot. The kinds differ in what
they hold and in what a change to them reaches, so the infrastructure track names a place for each, and the tooling looks a kind up through
the track instead of a path written in code. A template is where the three meet: it pulls its modules into one deployable `main.bicep`, and
each of its configuration slots deploys that one template into one resource group.

```yml drawio
description:
  "The infrastructure code has three kinds, each in its own place of the infrastructure track: reusable modules, templates and configuration
  slots. A template pulls the modules it references into its main.bicep, and one configuration slot deploys that template into one resource
  group."
about:
  adrs: [ADR-AZ-IACKIND-THREEKINDS, ADR-AZ-IACKIND-TRACKPLACESKINDS]
  lens: meta
content:
  title: Infrastructure code is of three kinds, and a template pulls its modules and its configuration slots together
  kind: explanation
  flow: left-to-right
  theme: dark
  bands:
    - { id: band-modules, label: MODULES }
    - { id: band-templates, label: TEMPLATE }
    - { id: band-configs, label: CONFIGURATION SLOTS }
    - { id: band-deployed, label: DEPLOYED }
  spans:
    - id: span-modules
      label: modules
      over: [band-modules]
    - id: span-templates
      label: templates
      over: [band-templates]
    - id: span-configs
      label: configs
      over: [band-configs]
  glyphs:
    - { id: g-module, kind: code, label: reusable module, in: band-modules }
    - { id: g-main, kind: code, label: main.bicep, in: band-templates }
    - { id: g-options, kind: file, label: options.yml, in: band-templates }
    - { id: g-slot, kind: file, label: "<env>[-<slot>].yml", in: band-configs }
    - { id: e-group, kind: env, label: resource group, in: band-deployed }
  edges:
    - { from: g-module, to: g-main, kind: flow, label: feeds }
    - { from: g-options, to: g-main, kind: flow, label: feeds }
    - { from: g-main, to: g-slot, kind: flow, label: "" }
    - { from: g-slot, to: e-group, kind: flow, label: in }
  markers:
    - { at: g-module, number: 1 }
    - { at: g-main, number: 2 }
    - { at: g-options, number: 3 }
    - { at: g-slot, number: 4 }
    - { at: e-group, number: 5 }
  legend: auto
  minimaps: [axis, lifecycle-position, layer-stack]
layout:
  g-slot: { x: 680, y: 164, w: 200, h: 52 }
```

![Infrastructure code is of three kinds, and a template pulls its modules and its configuration slots together][diagram]

[diagram]: .assets/three-kinds-of-infrastructure-code.drawio.png

## Walkthrough

1. **Reusable module.** One `.bicep` file under the track's `modules` place, such as a Log Analytics workspace or a Key Vault. A module is
   never deployed alone; it exists to be referenced, so a change to it reaches every template that uses it.
2. **main.bicep.** The template's deployable entry. It references the modules it needs with `module` declarations, and the build inlines
   them, so the built template is one file.
3. **options.yml.** The template's own settings, kept in its folder beside `main.bicep` and its `README.md`. The folder's name is the
   template's name.
4. **Configuration slot.** One `<env>[-<slot>].yml` file in the template's configuration folder, at the root for the shared platform or
   under a customer subfolder. Slot and customer names are discovered from disk, never listed.
5. **Resource group.** A slot deploys its template into exactly one resource group, so the configuration tree of a template is the list of
   its deployments.

## Why it holds

- The infrastructure code has three kinds, templates, their configuration slots and reusable modules, and every infrastructure file is of
  one kind (ADR-AZ-IACKIND-THREEKINDS).
- The infrastructure track names each kind's place under `kinds:` in `variants.yml`, and the tooling finds a kind only through
  `Get-TrackPlace`, so a repository that keeps its infrastructure elsewhere maps the three kinds and the tooling follows unchanged
  (ADR-AZ-IACKIND-TRACKPLACESKINDS).

## See also

- [Infrastructure kinds](../../drs/azure/infrastructure-kinds.md) — the decision this article explains.
- What a change to each kind reaches: [change one configuration slot](change-one-configuration-slot.md),
  [a module change fans out to its templates](a-module-change-fans-out-to-its-templates.md), [add a template](add-a-template.md) and
  [add a configuration slot](add-an-environment-slot.md).
- [The Azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)
