# pwsh/Base.Globs/Protect-GlobSet.ps1

The record half of the protected-glob skip: after a scan passes, it stores the globset's identity so the next unchanged run is skipped.

## help

### synopsis

Records a green scan against its globset's identity, so an unchanged repeat run can be skipped.

### description

The record half of the protected-glob skip ([ADR-REPO-PROTGLOB](../../../drs/repository/protected-globs.md)) — call it only AFTER the scan
passes, so a red scan is never cached away. It promotes the pending hash Test-GlobSetProtection captured before the scan (falling back to
computing one when the query was never asked). Session memory only; in a pipeline this is a no-op, so CI never records protection.

### parameter `Test`

The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown', or a Test-Automation run key).

### parameter `Name`

The scope's name in the protection key: a declared globset, or (with a prior -Hash query or -Hash here) any identifier the caller keys by.

### parameter `Hash`

A precomputed durable identity to record when no pending value exists for the key — for callers that protect directly without a prior
Test-GlobSetProtection query. A pending pre-scan value always wins over this (hash-before-scan,
[ADR-REPO-PROTGLOB-PROTECTIONKEY](../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-protectionkey)).

### example 1

```powershell
Test-Markdownlint
Protect-GlobSet -Test 'markdown' -Name 'markdown-scope'
```

## The cache

The lazy cache entries are probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## Naming the identity

The local that holds the recorded identity is never named `$hash`: PowerShell variables are case-insensitive, so it would silently overwrite
the `$Hash` parameter.
