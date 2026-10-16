---
catzc:
  immutable:
    with_body_sha: "0c8dd0e6f9a5"
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepParameterEntryViolations.ps1.md
    folder: docs/references/automation/catzc-azure-templates/private
    name: get-bicep-parameter-entry-violations-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Azure.Templates/private/Get-BicepParameterEntryViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($Parameter.IsSecure) {`, written with `#`.

```text
A secure parameter takes its value from a Key Vault at deploy time. A literal is a secret in the repository;
say so without ever echoing it.
```
