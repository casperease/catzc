---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/tests/Get-FirewallCsv.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-firewall/tests
    name: get-firewall-csv-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "71e1b2a9c4e2"
---

# automation/Catzc.Azure.Firewall/tests/Get-FirewallCsv.Tests.ps1

<!-- cspell:ignore etwork -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:blobJson = @'`, written with `#`.

```text
A realistic blob listing. The dd-MM-yyyy names do NOT sort chronologically by string:
'ApplicationRules-30-01-2026-...' is lexically largest but is January (older than June),
so a correct newest-by-filename-timestamp pick must return the June blobs.
```

## comment:2

Above `Mock Invoke-AzCli -ModuleName Catzc.Azure.Firewall {`, written with `#`.

```text
Default happy-path az mock: list returns the JSON above; download copies the matching fixture
to --file so the emitted Path points at a real CSV (nothing ever calls live ARM).
```
