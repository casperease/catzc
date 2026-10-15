---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRunFile.ps1.md
    kind: reference
    body_sha: "15b64a9a3005"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Get-TestRunFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The harness schedules, scopes, protects, and reports by run file — the unit a shard runs. For a *.Tests.ps1 test
that is its file. A language bridge test (tests/Language.Bridge.ps1, run once per Go or Python test folder as a
Pester container whose data names the folder) belongs to its test folder instead, read from the container data's
TestFolder, so a module's Go and Python tests count as that module's, not the bridge file's.
```
