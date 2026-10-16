---
catzc:
  immutable:
    with_body_sha: "029a80254290"
    repo_status: clean
    path: docs/explanation/repository/index.md
    folder: docs/explanation/repository
    name: index
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/index.md#repository
      - docs/explanation/index.md
---

# Repository explanations

```text
How the repository is kept in shape.

Root config materialisation   every managed root file comes from one source
Variant primitives            nothing reads variants.yml directly
```

These articles explain decisions from the [repository ADR domain](../../adr/index.md#repository). Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.
