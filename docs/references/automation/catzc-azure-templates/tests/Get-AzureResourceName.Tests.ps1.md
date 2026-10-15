---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/tests/Get-AzureResourceName.Tests.ps1.md
    kind: test-asset
    body_sha: "410de7c234ad"
---

# automation/Catzc.Azure.Templates/tests/Get-AzureResourceName.Tests.ps1

<!-- cspell:ignore alweutstsmplst weuwkspvm sttstsmplalweu alweusmplvm vmsmplalweu weutstsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
The pattern selects the env-segment (long → name, restricted → shortcode) and the separator
(hyphen for long/kv, none for storage/vm); the order arranges the segments. Base slot, so the
slot segment is dropped.
```
