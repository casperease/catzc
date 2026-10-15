---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Update-BatsVendor.Tests.ps1.md
    kind: test-asset
    body_sha: "3af9b71dc0a2"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Update-BatsVendor' -Tag 'L0', 'logic' {`.

```text
Update-BatsVendor with the download and tar mocked: the mocked tar lays out a fixture release in the staging folder,
and the vendored folder of a fixture repository in $TestDrive is rebuilt from it. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```
