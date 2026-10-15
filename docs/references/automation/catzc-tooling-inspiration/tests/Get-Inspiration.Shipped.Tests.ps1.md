---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/tests/Get-Inspiration.Shipped.Tests.ps1.md
    kind: test-asset
    body_sha: "7a19872e662b"
    adrs:
      - ADR-REPO-INSPIRE#1
---

# automation/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Shipped.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Get-Inspiration over the shipped inspiration.yml' -Tag 'L1',...`.

```text
The shipped inspiration.yml through the real Get-Config and the real repository root. It asserts consistency, never
presence: on a machine without eac the default inspiration is reported unavailable, and the test still passes
([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)).
```
