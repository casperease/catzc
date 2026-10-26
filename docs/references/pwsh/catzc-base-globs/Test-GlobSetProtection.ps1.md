# pwsh/Base.Globs/Test-GlobSetProtection.ps1

The query half of the protected-glob skip: it answers whether this scan already ran green against the globset's current identity.

## help

### synopsis

True when a scan may be skipped: this test already ran green against this globset's current identity.

### description

The query half of the protected-glob skip ([ADR-REPO-PROTGLOB](../../../drs/repository/protected-globs.md)): a heavy read-only scan is a
pure function of its globset's durable SHA, so a repeat run against an unchanged set proves nothing. The protection map is session memory
only — keyed `<test>|<globset>`, holding the durable SHA of the last green run — and in a pipeline it is never consulted: this returns
$false unconditionally, so CI always scans full.

A $false answer also records the just-computed hash as PENDING for that key; Protect-GlobSet promotes it after the scan passes. The hash is
therefore always the one computed BEFORE the scan — an edit that lands mid-scan makes the recorded identity stale and forces the next run to
scan again.

### parameter `Test`

The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown', or a Test-Automation run key).

### parameter `Name`

The scope's name in the protection key: a declared globset (whose hash is computed here) or, with -Hash, any identifier the caller keys by
(e.g. a module name whose composite identity the caller computed).

### parameter `Hash`

A precomputed durable identity to compare instead of hashing a declared globset — the path composite identities (per-module protection)
take. The pending-promote handshake is unchanged: this value is what Protect-GlobSet later promotes.

### example 1

```powershell
if (Test-GlobSetProtection -Test 'markdown' -Name 'markdown-scope') { return }
```

### example 2

```powershell
Test-GlobSetProtection -Test 'test-automation|L0-L2|Both' -Name 'Catzc.Base.Globs' -Hash $composite
```

## The cache

The lazy cache entries are probed strict-clean
([ADR-PWSH-CACHE-STRICTSAFEPROBE](../../../drs/automation/pwsh/script-scope-caching.md#rule-adr-pwsh-cache-strictsafeprobe)).

## Naming the identity

The local that holds the identity is never named `$hash`: PowerShell variables are case-insensitive, so it would silently overwrite the
`$Hash` parameter.
