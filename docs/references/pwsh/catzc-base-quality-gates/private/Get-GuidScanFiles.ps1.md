# pwsh/Catzc.Base.QualityGates/private/Get-GuidScanFiles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the repo-relative tracked files the managed-GUID scan reads — the scan's file universe.

### description

Tracked files (Get-GitTrackedPath,
[ADR-AUTO-TRACKED-ONESEAM](../../../../drs/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked-oneseam) — the same matching
universe as the globsets,
[FDR-CD-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)), minus what the
scan must not read: vendored third-party code (pwsh/.vendor/), the committed compiled assembly (pwsh/.compiled/), known binary extensions,
and the registry file itself — configs/guids.yml is the definition of the managed set, not a reference to it, and excluding it is what keeps
the liveness check honest. The one place this scan reads the tracked set; a logic test mocks this seam (returning absolute fixture paths,
which Resolve-RepoPath passes through unchanged). Throws in build mode (Assert-SourceTree).

## comment:1

Above `Assert-SourceTree`, written with `#`.

```text
The universe and its exclusions (pwsh/.vendor, pwsh/.compiled, the registry) are the catzc
source repository's layout, so the scan is meaningful only over the source tree.
```
