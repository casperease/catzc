# pwsh/Base.Globs/tests/Test-GlobSetProtection.Tests.ps1

The tests of `Test-GlobSetProtection` and `Protect-GlobSet`, the protected-glob skip
([ADR-REPO-PROTGLOB](../../../../drs/repository/protected-globs.md)).

## What it proves

A repeated green scan over an unchanged globset is skipped from session memory. The hash is taken before the scan, through the
pending-promote handshake, and a pending value wins over a hash passed later
([ADR-REPO-PROTGLOB-PROTECTIONKEY](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-protectionkey)). In pipelines the
skip is completely ignored.
