---
catzc:
  immutable:
    with_body_sha: "618fc4ca8cbe"
    repo_status: locked
    path: docs/references/automation/catzc-azure-devops/tests/Test-Pipelines.Tests.ps1.md
    folder: docs/references/automation/catzc-azure-devops/tests
    name: test-pipelines-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-PESTER#2
---

# automation/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Get-AdoYamlFiles -ModuleName Catzc.Azure.DevOps { $script:records }`, written with `#`.

```text
Isolate through the classifier + reference-scan seams
([ADR-PWSH-PESTER#2](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester2)).
```
