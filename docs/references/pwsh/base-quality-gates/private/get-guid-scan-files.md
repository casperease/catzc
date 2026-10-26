# pwsh/Base.QualityGates/private/Get-GuidScanFiles.ps1

The file universe of the managed-GUID scan: the repository's tracked files minus vendored code, the compiled assembly, known binary
extensions and the registry file. It is the one place the scan reads the tracked set, so a logic test mocks this seam.

## help

### synopsis

Returns the repo-relative tracked files the managed-GUID scan reads — the scan's file universe.

### description

Tracked files (Get-GitTrackedPath,
[ADR-AUTO-TRACKED-ONESEAM](../../../../drs/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked-oneseam) — the same matching
universe as the globsets, [FDR-CD-GLOBS-TRACKEDFILESONLY](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)),
minus what the scan must not read: vendored third-party code (pwsh/.vendor/), the committed compiled assembly (pwsh/.compiled/), known
binary extensions, and the registry file itself — configs/guids.yml is the definition of the managed set, not a reference to it, and
excluding it is what keeps the liveness check honest. The one place this scan reads the tracked set; a logic test mocks this seam (returning
absolute fixture paths, which Resolve-RepoPath passes through unchanged). Throws in build mode (Assert-SourceTree).

## source tree only

The universe and its exclusions (`pwsh/.vendor`, `pwsh/.compiled`, the registry) are the catzc source repository's layout, so the scan is
meaningful only over the source tree. The function throws in build mode through Assert-SourceTree.
