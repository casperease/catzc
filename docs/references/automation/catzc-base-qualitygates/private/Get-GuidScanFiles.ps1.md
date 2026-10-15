---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-GuidScanFiles.ps1.md
    kind: comment-page
    body_sha: be85bdc8f607
    adrs:
      - ADR-AUTO-TRACKED#1
      - ADR-FLOW-CD-GLOBS#4
---

# automation/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Tracked files (Get-GitTrackedPath,
[ADR-AUTO-TRACKED#1](/docs/adr/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked1) — the same matching universe as the globsets,
[ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)), minus what the
scan must not read: vendored third-party code (automation/.vendor/), the committed compiled assembly
(automation/.compiled/), known binary extensions, and the registry file itself — configs/guids.yml is
the definition of the managed set, not a reference to it, and excluding it is what keeps the liveness
check honest. The one place this scan reads the tracked set; a logic test mocks this seam (returning absolute
fixture paths, which Resolve-RepoPath passes through unchanged). Throws in build mode (Assert-SourceTree).
```

## comment:2

Above `Assert-SourceTree`.

```text
The universe and its exclusions (automation/.vendor, automation/.compiled, the registry) are the catzc
source repository's layout, so the scan is meaningful only over the source tree.
```

## comment:3

Above `Assert-SourceTree`.

```text
The universe and its exclusions (automation/.vendor, automation/.compiled, the registry) are the catzc
source repository's layout, so the scan is meaningful only over the source tree.
```
