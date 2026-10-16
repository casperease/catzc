---
catzc:
  immutable:
    with_body_sha: "7e3f927bebba"
    path: docs/references/automation/catzc-tooling-node.md
    folder: docs/references/automation
    name: catzc-tooling-node
    filetype: md
    kind: reference
    language: markdown
    track: docs
  edges:
    links:
      - docs/adr/automation/controlling-systemwide-deps.md
      - docs/adr/automation/cross-platform.md
      - docs/adr/automation/use-proper-package-managers.md
      - docs/references/automation/catzc-base-qualitygates.md
      - docs/references/automation/catzc-tooling-core.md
---

# Catzc.Tooling.Node

The Node.js ecosystem module of the Tooling group. It owns the Node runtime and npm, and the npm-delivered quality tools the repository's
quality gates run on — cSpell, markdownlint, and Prettier — each pinned to its locked version through the generic engine in
[Catzc.Tooling.Core](catzc-tooling-core.md). It carries no engine of its own; it is the thin, Node-specific surface over Core, and it
installs through npm per [use-proper-package-managers](../../adr/automation/use-proper-package-managers.md) and
[controlling-systemwide-deps](../../adr/automation/controlling-systemwide-deps.md).

## Responsibilities

| Responsibility   | Area      | Name                                                                         |
| ---------------- | --------- | ---------------------------------------------------------------------------- |
| responsibility:1 | runtime   | [Node runtime and npm](#responsibility1--node-runtime-and-npm)               |
| responsibility:2 | npm-tools | [npm-installed quality tools](#responsibility2--npm-installed-quality-tools) |

### responsibility:1 — Node runtime and npm

The runtime itself: install the locked Node.js idempotently, uninstall the managed install, hard-remove an unmanaged one, and run npm
through the asserted execution wrapper. npm is the package manager the module's other tools install through, so it lives here with the
runtime that provides it.

### responsibility:2 — npm-installed quality tools

The tools that ride on npm — cSpell (spell-checking), markdownlint (Markdown linting), and Prettier (formatting) — each with the same
install and uninstall shape over Core's engine, pinned to its locked version. These are the binaries the repository's quality gates in
[Catzc.Base.QualityGates](catzc-base-qualitygates.md) shell out to; this module is what puts them on the machine.

## What the module does

The module depends on [Catzc.Tooling.Core](catzc-tooling-core.md) and only that module within the group. Every per-tool function hands its
tool name to Core's engine, which reads `tools.yml` for the locked version and the npm identifier and then installs, asserts, or removes
idempotently — there is no Node-specific install logic outside that delegation.

The two responsibilities are the runtime and what rides on it. Responsibility 1 owns Node and npm — the package manager responsibility 2
needs; responsibility 2 owns the quality tools that are themselves npm packages. The relationship to the quality gates is one-way: the gates
invoke these tools at runtime, while this module owns only installing and locking them. The same functions run locally and in CI (see
[cross-platform](../../adr/automation/cross-platform.md)).

## Division

The module's public functions, sorted into the responsibilities above.

| Responsibility                                 | Function                 |
| ---------------------------------------------- | ------------------------ |
| responsibility:1 — Node runtime and npm        | `Install-NodeJs`         |
|                                                | `Invoke-Npm`             |
|                                                | `Uninstall-NodeJs`       |
|                                                | `Remove-NodeJs`          |
| responsibility:2 — npm-installed quality tools | `Install-Cspell`         |
|                                                | `Uninstall-Cspell`       |
|                                                | `Install-Markdownlint`   |
|                                                | `Uninstall-Markdownlint` |
|                                                | `Install-Prettier`       |
|                                                | `Uninstall-Prettier`     |
