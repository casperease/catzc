---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md
    kind: test-asset
    body_sha: "11df64c48cb8"
    adrs:
      - ADR-AUTO-PATH#11
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Resolve-InspirationRoot' -Tag 'L0', 'logic' {`.

```text
Resolve-InspirationRoot over a TestDrive workspace with neutral names (widget/gadget,
[ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); Get-RepositoryRoot is the mocked
boundary. The {workspace} anchor resolves to the parent of the repository root
([ADR-AUTO-PATH#11](/docs/adr/automation/path-representation.md#rule-adr-auto-path11)), the same from pwsh's and
Git Bash's view of that root, and the result is a normalized absolute path.
```
