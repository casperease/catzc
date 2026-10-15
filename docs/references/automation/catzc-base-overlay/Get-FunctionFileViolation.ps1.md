---
catzc:
  derived:
    path: docs/references/automation/catzc-base-overlay/Get-FunctionFileViolation.ps1.md
    kind: comment-page
    body_sha: bb65e8419c5d
    adrs:
      - ADR-AUTO-ASSETDEP#1
      - ADR-PWSH-MANIFEST#5
    links: []
---

# automation/Catzc.Base.Overlay/Get-FunctionFileViolation.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The one check of a function file's shape, read from its syntax tree, shared by the two places that load a
function file away from the folder it was written in: the build, which merges a module's function files into one
file (the merge preconditions,
[ADR-PWSH-MANIFEST#5](/docs/adr/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest5)), and a consumer
overlay, whose override file is loaded into a built module
([ADR-AUTO-OVERLAY](/docs/adr/automation/consumer-overlay.md)). A file passes when it parses; it defines exactly
one function, named for the file, and nothing else at the top level (no param block, no begin/process blocks,
no other statement); it carries no `using` statement and no `#requires`; and it never reads $PSScriptRoot,
which names another folder once the file is loaded elsewhere
([ADR-AUTO-ASSETDEP#1](/docs/adr/automation/internal-asset-dependencies.md#rule-adr-auto-assetdep1)).
```
