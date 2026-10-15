---
catzc:
  derived:
    path: docs/explanation/pipelines/index.md
    kind: explanation
    body_sha: "57680316fafd"
    links:
      - docs/adr/index.md#pipelines
      - docs/adr/pipelines/dual-authentication.md
      - docs/explanation/index.md
      - docs/explanation/pipelines/configured-credential-proves-its-org.md
      - docs/explanation/pipelines/one-header-function-owns-precedence.md
      - docs/explanation/pipelines/three-guarded-early-returns.md
      - docs/explanation/pipelines/what-you-set-decides-the-credential.md
      - docs/explanation/pipelines/which-auth-rungs-have-a-gate.md
---

# Pipelines explanations

```text
How Azure DevOps REST calls choose and prove their credentials.

Azure DevOps auth precedence   the first configured credential wins, and it must prove its org
```

These articles explain decisions from the [pipelines ADR domain](../../adr/index.md#pipelines). Each article narrates one diagram; the
[explanation index](../index.md) says how to read them.

## Azure DevOps auth precedence

The first configured credential wins, and it must prove its org ([dual-authentication](../../adr/pipelines/dual-authentication.md)).

| Lens           | Article                                                                                                                        |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| meta           | [The first configured credential wins, and it must prove its org](configured-credential-proves-its-org.md)                     |
| architecture   | [One function owns the credential precedence, and ado.yml anchors every proof](one-header-function-owns-precedence.md)         |
| implementation | [The header function is four checks and three returns, and none falls through on failure](three-guarded-early-returns.md)      |
| operations     | [What you set decides the credential, and each wrong setup stops with its own message](what-you-set-decides-the-credential.md) |
| governance     | [The PAT proof and the empty-token assert have no gate](which-auth-rungs-have-a-gate.md)                                       |
