---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
    kind: comment-page
    body_sha: e1df29d69fc9
    adrs:
      - ADR-FLOW-CD-GLOBS#1
---

# automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The blast-radius query (the third marker role,
[ADR-FLOW-CD-GLOBS#1](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs1)): maps changed files onto every
globset
whose effective membership matches at least one of them — the declared registry (tracks,
deployable-units, scopes; compose-aware) AND the derived module sets
([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)), so the answer
covers both "which pipelines/units this fires" (Pipeline) and "which tests verify it" (the derived
module rows name the modules for Test-Automation -Modules; a declared row's VerifyModules/VerifyLevel
carry its configured verify scope — its test suite, run by name with Test-Automation -Suite).
```

## comment:2

Section `.PARAMETER Ref` of the comment-based help.

```text
A git ref to diff the working tree against (`git diff --name-only <ref>`) instead of naming files —
e.g. 'main' answers "what does my branch touch".
```

## comment:3

Above `foreach ($set in @(Get-GlobSet) + @(Get-ModuleGlobSet)) {`.

```text
Declared sets first (registry order), then the derived module sets — the same one-answer-per-set
shape either way.
```
