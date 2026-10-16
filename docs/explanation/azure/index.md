---
catzc:
  derived:
    path: docs/explanation/azure/index.md
    folder: docs/explanation/azure
    name: index
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    body_sha: ee060595c823
    links:
      - docs/adr/azure/azure-naming-standard.md
      - docs/adr/index.md#azure
      - docs/explanation/azure/how-each-naming-rule-is-held.md
      - docs/explanation/azure/lookup-form-check-render-in-order.md
      - docs/explanation/azure/names-are-derived-never-typed.md
      - docs/explanation/azure/names-are-pure-and-never-truncated.md
      - docs/explanation/azure/one-namer-assembles-every-name.md
      - docs/explanation/index.md
---

# Azure explanations

```text
How cats models and names what it deploys onto Azure.

Azure name assembly   a name is a pure function of its components, never typed, never truncated
```

These articles explain decisions from the [azure ADR domain](../../adr/index.md#azure): how a resource name is assembled from the identity
data model and never typed by hand. Each article narrates one diagram; the [explanation index](../index.md) says how to read them.

## Azure name assembly

An Azure name is a pure function of its components, and it is never truncated
([azure-naming-standard](../../adr/azure/azure-naming-standard.md)).

| Lens           | Article                                                                                                                |
| -------------- | ---------------------------------------------------------------------------------------------------------------------- |
| meta           | [An Azure name is a pure function of its components, and it is never truncated](names-are-pure-and-never-truncated.md) |
| architecture   | [One resolver gathers the components and one namer assembles every Azure name](one-namer-assembles-every-name.md)      |
| implementation | [The namer looks up, forms, checks and renders a name in that order](lookup-form-check-render-in-order.md)             |
| operations     | [Nobody types an Azure name: cats derives it, and a bad name stops with an error](names-are-derived-never-typed.md)    |
| governance     | [Code holds all eight naming rules, seven of them behind a check that throws](how-each-naming-rule-is-held.md)         |
