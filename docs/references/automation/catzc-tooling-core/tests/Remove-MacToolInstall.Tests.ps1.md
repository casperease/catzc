---
catzc:
  immutable:
    with_body_sha: "2569b8f983c4"
    path: docs/references/automation/catzc-tooling-core/tests/Remove-MacToolInstall.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-core/tests
    name: remove-mac-tool-install-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:config = [pscustomobject]@{ command = 'widget'; pip_package =...`, written with `#`.

```text
A neutral fixture tool
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)) — never a real tool identity.
```
