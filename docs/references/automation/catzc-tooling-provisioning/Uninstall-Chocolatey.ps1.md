---
catzc:
  immutable:
    with_body_sha: "7efd424120ab"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning
    name: uninstall-chocolatey-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#33
---

# automation/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Set-PermanentEnvironmentVariable ChocolateyInstall $null -Scope Machine`, written with `#`.

```text
Remove environment variable
the seam announces each removal, and does nothing in a scope where the variable is not set
```

## comment:2

Above `foreach ($scope in 'Machine', 'User') {`, written with `#`.

```text
Remove Chocolatey from PATH — through the PATH seams, which announce the change
([ADR-AUTO-TEST#33](/docs/adr/automation/test-automation.md#rule-adr-auto-test33))
```
