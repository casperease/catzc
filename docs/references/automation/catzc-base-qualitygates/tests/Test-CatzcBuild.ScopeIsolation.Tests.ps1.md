---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1.md
    kind: test-asset
    body_sha: "0c6cabb9f0ac"
    adrs:
      - ADR-DSGN-RUNMODE#3
---

# automation/Catzc.Base.QualityGates/tests/Test-CatzcBuild.ScopeIsolation.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Module script scopes are never shared' -Tag 'ADR-DSGN-RUNMODE#3' {`.

```text
Scope isolation ([ADR-DSGN-RUNMODE#3](/docs/adr/design/run-modes.md#rule-adr-dsgn-runmode3)): two catzc modules that
hold a $script: variable of the same name never see
each other's value — in either run mode. The probe variable name is the test's own and is removed afterwards; no
module code reads it. The modules are chosen generically (the first two loaded catzc modules by name), never by
a production identity.
```

## comment:2

Above `$script:probeBlock = {`.

```text
Sets the probe in each module's script scope (widget, gadget, …), reads every module's variable and the
global one back, then removes the probes. Self-contained so it also runs in a child pwsh.
```

## comment:3

Above `Context 'in the loaded session' -Tag 'L1', 'logic' {`.

```text
In-process, in whichever mode this session runs: the source run proves the source mode, the build run (where
this file runs against the built modules) proves build mode.
```

## comment:4

Above `Context 'in a fresh build' -Tag 'L2', 'logic', 'greedy', 'source-only' {`.

```text
A fresh build entered in a child pwsh. source-only: it builds from the source tree itself (Build-Modules needs
the per-function files) and isolates the build in its own process, so the answer does not depend on the mode
of the session running it. greedy: one build plus one importer-loading child pwsh.
```
