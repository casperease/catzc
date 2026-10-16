---
catzc:
  immutable:
    with_body_sha: ce47fa6c31f7
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/tests/Get-AzureResourceName.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-templates/tests
    name: get-azure-resource-name-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Templates/tests/Get-AzureResourceName.Tests.ps1

<!-- cspell:ignore alweutstsmplst weuwkspvm sttstsmplalweu alweusmplvm vmsmplalweu weutstsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `BeforeAll {`, written with `#`.

```text
The pattern selects the env-segment (long → name, restricted → shortcode) and the separator
(hyphen for long/kv, none for storage/vm); the order arranges the segments. Base slot, so the
slot segment is dropped.
```
