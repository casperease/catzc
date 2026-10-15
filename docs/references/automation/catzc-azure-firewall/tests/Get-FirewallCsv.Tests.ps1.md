---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/tests/Get-FirewallCsv.Tests.ps1.md
    kind: test-asset
    body_sha: "34a009fb58a5"
---

# automation/Catzc.Azure.Firewall/tests/Get-FirewallCsv.Tests.ps1

<!-- cspell:ignore etwork -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:blobJson = @'`.

```text
A realistic blob listing. The dd-MM-yyyy names do NOT sort chronologically by string:
'ApplicationRules-30-01-2026-...' is lexically largest but is January (older than June),
so a correct newest-by-filename-timestamp pick must return the June blobs.
```

## comment:2

Above `Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {`.

```text
Default happy-path az mock: list returns the JSON above; download copies the matching fixture
to --file so the emitted Path points at a real CSV (nothing ever calls live ARM).
```
