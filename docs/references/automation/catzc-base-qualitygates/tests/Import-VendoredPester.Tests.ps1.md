---
catzc:
  immutable:
    with_body_sha: "8c72e049afa6"
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/tests/Import-VendoredPester.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: import-vendored-pester-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/tests/Import-VendoredPester.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:codeRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))`, written with `#`.

```text
A fake code root with one vendored version; every module operation is mocked, so the Pester running this
test is never touched.
```
