# docs/references/automation/catzc-base-globs/Test-GlobSetProtection.ps1.md

`automation/Catzc.Base.Globs/Test-GlobSetProtection.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The query half of the protected-glob skip
([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): a heavy read-only scan is a pure function of
its globset's durable SHA, so a repeat run against an unchanged set proves nothing. The protection map
is session memory only — keyed <test>|<globset>, holding the durable SHA of the last green run — and in
a pipeline it is never consulted: this returns $false unconditionally, so CI always scans full.

A $false answer also records the just-computed hash as PENDING for that key; Protect-GlobSet promotes
it after the scan passes. The hash is therefore always the one computed BEFORE the scan — an edit that
lands mid-scan makes the recorded identity stale and forces the next run to scan again.
```

## comment:2

Section `.PARAMETER Test` of the comment-based help.

```text
The scan's name — the caller's identity in the protection key (e.g. 'spelling', 'markdown', or a
Test-Automation run key).
```

## comment:3

Section `.PARAMETER Name` of the comment-based help.

```text
The scope's name in the protection key: a declared globset (whose hash is computed here) or, with -Hash,
any identifier the caller keys by (e.g. a module name whose composite identity the caller computed).
```

## comment:4

Section `.PARAMETER Hash` of the comment-based help.

```text
A precomputed durable identity to compare instead of hashing a declared globset — the path composite
identities (per-module protection) take. The pending-promote handshake is unchanged: this value is what
Protect-GlobSet later promotes.
```

## comment:5

Above `$script:protectedGlobSets = @{}`.

```text
strict-clean probe of the lazy cache entries
([ADR-PWSH-CACHE#4](/docs/adr/pwsh/script-scope-caching.md#rule-adr-pwsh-cache4))
```

## comment:6

Above `$identity = if ($Hash) {`.

```text
NOTE: never name this local $hash — PowerShell variables are case-insensitive, so it would silently
overwrite the $Hash parameter.
```
