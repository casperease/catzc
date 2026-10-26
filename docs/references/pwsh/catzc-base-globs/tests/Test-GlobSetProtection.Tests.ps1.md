# pwsh/Catzc.Base.Globs/tests/Test-GlobSetProtection.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-GlobSetProtection / Protect-GlobSet'`, written with `#`.

```text
The protected-glob skip ([ADR-REPO-PROTGLOB](/docs/drs/repository/protected-globs.md)): session-memory skip of a
repeated green scan over an unchanged
globset; hash-before-scan via the pending-promote handshake; completely ignored in pipelines.
```

## comment:2

Above `Protect-GlobSet -Test 'suite' -Name 'Some.Module' -Hash ('d' * 64)`, written with `#`.

```text
pending wins
([ADR-REPO-PROTGLOB-PROTECTIONKEY](/docs/drs/repository/protected-globs.md#rule-adr-repo-protglob-protectionkey))
```
